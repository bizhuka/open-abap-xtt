import { readdir } from "node:fs/promises";

const color = (code, v) => console.log(`\x1b[${code}m${v}\x1b[0m`);
const red = (v) => color(31, v);

async function run() {
    try {
        await import("../output/_init.mjs");

        let buf = "";
        globalThis.abap.console.add = (data) => {
            globalThis.abap.console.empty = false;
            buf += data;
            const lines = buf.split("\n");
            buf = lines.pop();
            lines.forEach(red);
        };
        const flush = () => { if (buf) red(buf); buf = ""; };

        // const out = new globalThis.abap.types.ABAPObject({ qualifiedName: "IF_OO_ADT_CLASSRUN_OUT" });
        // out.set({
        //     if_oo_adt_classrun_out$write: async ({ data }) => { red(data.get()); return out; }
        // });

        // const outDir = new URL("../output/", import.meta.url);
        // const files = await readdir(outDir);
        // for (const file of files.filter(f => /^ztest_.*\.prog\.mjs$/i.test(f)).sort()) {
        //     const name = file.replace(/\.prog\.mjs$/i, "").toUpperCase();
        //     console.warn(`\n=== Running ${name} ===`);
        //     await import(`../output/${file}`);
        //     flush();
        // }

        // for (const name of Object.keys(globalThis.abap.Classes)) {
        //     if (!name.startsWith("ZCL_TEST_")) continue;
        //     console.warn(`\n=== Running ${name} ===`);
        //     const instance = await new globalThis.abap.Classes[name]().constructor_();
        //     await instance.if_oo_adt_classrun$main?.({ out });
        //     flush();
        // }

        const CL_OPEN_REPORT = globalThis.abap.Classes.ZCL_XTT_OPEN_REPORT;
        console.warn(`\n=== Running ZCL_XTT_OPEN_REPORT ===`);
        const instance = await new CL_OPEN_REPORT().constructor_();
        await instance.make_all();
        flush();
    } catch (error) {
        console.error("ABAP Runtime Error:", error);
        process.exitCode = 1;
    }
}

run();
