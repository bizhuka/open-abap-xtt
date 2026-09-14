import { readdir } from "node:fs/promises";

const outputDirectory = new URL("../output/", import.meta.url);
let outputBuffer = "";

const red = (value) => `\x1b[31m${value}\x1b[0m`;

function textOf(value) {
    if (typeof value === "string") {
        return value;
    }
    if (value && typeof value.get === "function") {
        return value.get();
    }
    return String(value);
}

function flushOutput() {
    if (outputBuffer.length > 0) {
        console.log(`  ${outputBuffer}`);
        outputBuffer = "";
    }
}

function errorFieldText(value) {
    if (typeof value === "string") {
        return value.trim();
    }
    if (value && typeof value.get === "function") {
        return textOf(value).trim();
    }
    if (typeof value?.value === "string") {
        return value.value.trim();
    }
    return "";
}

function formatError(error) {
    const message = errorFieldText(error?.msgv1) || errorFieldText(error?.msg);
    if (message.length > 0) {
        return message;
    }

    const expected = errorFieldText(error?.expected);
    const actual = errorFieldText(error?.actual);
    if (expected.length > 0 || actual.length > 0) {
        return `Expected '${expected}', got '${actual}'`;
    }

    return error?.message ?? String(error);
}

function patchDefaultDateTimeFormat() {
    const OriginalDateTimeFormat = Intl.DateTimeFormat;

    // Override Intl.DateTimeFormat to replace "default" with a locale using dots & 24-hour time.
    globalThis.Intl.DateTimeFormat = function DateTimeFormat(locales, options) {
        if (locales === "default" || locales === undefined) {
            locales = "de-DE";
        }

        return new OriginalDateTimeFormat(locales, options);
    };

    Object.setPrototypeOf(globalThis.Intl.DateTimeFormat, OriginalDateTimeFormat);
    globalThis.Intl.DateTimeFormat.prototype = OriginalDateTimeFormat.prototype;
}

async function run() {
    patchDefaultDateTimeFormat();

    const init = await import("../output/_init.mjs");

    globalThis.abap.console.add = (data) => {
        outputBuffer += textOf(data);
        const lines = outputBuffer.split("\n");
        outputBuffer = lines.pop() ?? "";
        for (const line of lines) {
            console.log(`  ${line}`);
        }
    };

    const files = (await readdir(outputDirectory))
        .filter((file) => /\.clas\.testclasses\.mjs$/i.test(file))
        .sort();

    if (files.length === 0) {
        throw new Error("No generated ABAP test-class modules found");
    }

    let total = 0;
    let failed = 0;

    // Fresh, fully-seeded database per test-class module so tests can't leak state to each other.
    await init.initializeABAP();

    for (const file of files) {
        let testModule;
        try {
            testModule = await import(new URL(file, outputDirectory));
        } catch (error) {
            failed++;
            console.error(red(`\nFAIL ${file}: ${formatError(error)}`));
            continue;
        }

        const testClasses = Object.entries(testModule)
            .filter(([name, value]) => name.startsWith("lcl_") && typeof value === "function" && value.METHODS)
            .sort(([left], [right]) => left.localeCompare(right));

        for (const [exportName, TestClass] of testClasses) {
            const methods = Object.keys(TestClass.METHODS)
                .filter((method) => !method.startsWith("_"))
                .sort();

            for (const methodKey of methods) {                
                total++;
                const methodName = methodKey.toLowerCase();
                const label = `${TestClass.INTERNAL_NAME ?? exportName}.${methodName}`;
                console.log(`\n=== ${label} ===`);

                try {
                    const instance = await new TestClass().constructor_();
                    if (typeof instance[methodName] !== "function") {
                        throw new Error(`Generated method '${methodName}' was not found`);
                    }
                    await instance[methodName]();
                    flushOutput();
                    console.log(`PASS ${label}`);
                } catch (error) {
                    flushOutput();
                    failed++;
                    console.error(red(`FAIL ${label}: ${formatError(error)}`));
                }
            }
        }
    }

    flushOutput();
    console.log(`\nExecuted ${total} test methods: ${total - failed} passed, ${failed} failed.`);
    if (failed > 0) {
        process.exitCode = 1;
    }
}

run().catch((error) => {
    console.error(red(`Test runner failed: ${formatError(error)}`));
    process.exitCode = 1;
});
