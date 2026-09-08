import { existsSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import express from "express";

const rootDir = dirname(fileURLToPath(new URL(".", import.meta.url)));
const initPath = join(rootDir, "output", "_init.mjs");
const publicDir = join(rootDir, "web", "public");

const EXAMPLES = [
    { id: "Z_XTT_DEMO_N010", description: "Simple structure" },
    { id: "Z_XTT_DEMO_N020", description: "Basic table example" },
    { id: "Z_XTT_DEMO_N021", description: "Different formulas" },
    { id: "Z_XTT_DEMO_N022", description: "Merging cells (Flight Model)" },
    { id: "Z_XTT_DEMO_N030", description: "Nested blocks" },
    { id: "Z_XTT_DEMO_N040", description: "Data types" },
    { id: "Z_XTT_DEMO_N050", description: "Tree group by fields" },
    { id: "Z_XTT_DEMO_N051", description: "Output level by condition" },
    { id: "Z_XTT_DEMO_N052", description: "Aggregation functions" },
    { id: "Z_XTT_DEMO_N060", description: "Tree (group by field relations)" },
    { id: "Z_XTT_DEMO_N070", description: "Macro call & on_prepare_raw" },
    { id: "Z_XTT_DEMO_N080", description: "direction=column" },
    { id: "Z_XTT_DEMO_N090", description: "Dynamic table (tree)" },
    { id: "Z_XTT_DEMO_N091", description: "Many sheets and columns" },
    { id: "Z_XTT_DEMO_N092", description: "Dynamic table (new syntax)" },
    { id: "Z_XTT_DEMO_N100", description: "Images" },
    { id: "Z_XTT_DEMO_N110", description: "Image template declaration" },
    { id: "Z_XTT_DEMO_N120", description: "Class attributes" },
    { id: "Z_XTT_DEMO_N130", description: "COND #( ) operator" },
    { id: "Z_XTT_DEMO_N140", description: ";type=block" },
    { id: "Z_XTT_DEMO_N160", description: ";call=" },
];

if (!existsSync(initPath)) {
    console.error("Missing output/_init.mjs. Run npm run verify first (or set VERIFY_ON_START=1 on the server).");
    process.exit(1);
}

function patchDefaultDateTimeFormat() {
    const OriginalDateTimeFormat = Intl.DateTimeFormat;
    globalThis.Intl.DateTimeFormat = function DateTimeFormat(locales, options) {
        if (locales === "default" || locales === undefined) {
            locales = "de-DE";
        }
        return new OriginalDateTimeFormat(locales, options);
    };
    Object.setPrototypeOf(globalThis.Intl.DateTimeFormat, OriginalDateTimeFormat);
    globalThis.Intl.DateTimeFormat.prototype = OriginalDateTimeFormat.prototype;
}

function textOf(value) {
    if (value == null) {
        return "";
    }
    if (typeof value === "string" || typeof value === "number") {
        return String(value).trim();
    }
    if (typeof value.get === "function") {
        return textOf(value.get());
    }
    return String(value).trim();
}

function isAbapTrue(value) {
    const text = textOf(value);
    return text === "X" || text === "true" || text === "1";
}

function createTyped(factory, fallback) {
    try {
        if (typeof factory === "function") {
            return factory();
        }
    } catch {
        // use fallback
    }
    return fallback();
}

function abapString(value = "") {
    const result = new globalThis.abap.types.String({ qualifiedName: "STRING" });
    result.set(value ?? "");
    return result;
}

function abapInteger(value) {
    const result = new globalThis.abap.types.Integer({ qualifiedName: "INT4" });
    result.set(Number(value) || 0);
    return result;
}

function abapNumc2(value) {
    const Numc = globalThis.abap.types.Numc;
    const result = Numc
        ? new Numc({ length: 2, qualifiedName: "NUMC2" })
        : new globalThis.abap.types.Character({ length: 2, qualifiedName: "NUMC2" });
    result.set(String(value ?? "0").padStart(2, "0"));
    return result;
}

function abapXString() {
    return new globalThis.abap.types.XString({ qualifiedName: "XSTRING" });
}

function xstringToBuffer(value) {
    const hex = textOf(value).replace(/\s+/g, "");
    if (!hex) {
        return Buffer.alloc(0);
    }
    return Buffer.from(hex, "hex");
}

function parseCount(value, fallback) {
    const number = Number.parseInt(String(value ?? ""), 10);
    return Number.isFinite(number) ? number : fallback;
}

let abapQueue = Promise.resolve();
function withAbap(work) {
    const run = abapQueue.then(work, work);
    abapQueue = run.catch(() => undefined);
    return run;
}

patchDefaultDateTimeFormat();
const init = await import("../output/_init.mjs");
await init.initializeABAP();

const TestClass = globalThis.abap.Classes.ZCL_TEST_XTT_01;
if (!TestClass) {
    console.error("ZCL_TEST_XTT_01 is not loaded. Run npm run verify.");
    process.exit(1);
}

async function callMeta(exampleId) {
    const instance = await new TestClass().constructor_();
    const params = TestClass.METHODS?.GET_EXAMPLE_META?.parameters ?? {};
    const esOpt = createTyped(params.ES_OPT?.type, () => new globalThis.abap.types.Structure({
        row_count: new globalThis.abap.types.Character(1, { qualifiedName: "ABAP_BOOL" }),
        colum_count: new globalThis.abap.types.Character(1, { qualifiedName: "ABAP_BOOL" }),
        block_count: new globalThis.abap.types.Character(1, { qualifiedName: "ABAP_BOOL" }),
        zip: new globalThis.abap.types.Character(1, { qualifiedName: "ABAP_BOOL" }),
        img_size: new globalThis.abap.types.Character(1, { qualifiedName: "ABAP_BOOL" }),
    }, "zcl_xtt_demo=>ts_screen_opt"));
    const etTemplates = createTyped(params.ET_TEMPLATES?.type, () => globalThis.abap.types.TableFactory.construct(
        new globalThis.abap.types.Structure({
            objid: new globalThis.abap.types.Character(40, {}),
        }, "zcl_xtt_demo=>ts_template"),
        { withHeader: false, keyType: "DEFAULT" },
        "zcl_xtt_demo=>tt_template",
    ));
    const evError = abapString();

    await instance.get_example_meta({
        iv_example: abapString(exampleId),
        es_opt: esOpt,
        et_templates: etTemplates,
        ev_error: evError,
    });

    const error = textOf(evError);
    if (error) {
        return { error };
    }

    const templates = [];
    for (const row of etTemplates.array()) {
        const objid = textOf(row.get ? row.get().objid : row.objid);
        if (objid) {
            templates.push({ objid });
        }
    }

    const opt = esOpt.get ? esOpt.get() : esOpt;
    return {
        row_count: isAbapTrue(opt.row_count),
        colum_count: isAbapTrue(opt.colum_count),
        block_count: isAbapTrue(opt.block_count),
        templates,
    };
}

async function callGenerate({ example, template, rCnt, cCnt, bCnt }) {
    const instance = await new TestClass().constructor_();
    const evRaw = abapXString();
    const evFilename = abapString();
    const evMimetype = abapString();
    const evError = abapString();

    await instance.generate({
        iv_example: abapString(example),
        iv_template: abapString(template),
        iv_r_cnt: abapInteger(rCnt),
        iv_c_cnt: abapNumc2(cCnt),
        iv_b_cnt: abapInteger(bCnt),
        ev_raw: evRaw,
        ev_filename: evFilename,
        ev_mimetype: evMimetype,
        ev_error: evError,
    });

    const error = textOf(evError);
    if (error) {
        return { error };
    }

    return {
        buffer: xstringToBuffer(evRaw),
        filename: textOf(evFilename) || "report.bin",
        mimetype: textOf(evMimetype) || "application/octet-stream",
    };
}

const app = express();
app.use(express.json({ limit: "1mb" }));
app.use(express.urlencoded({ extended: false }));
app.use(express.static(publicDir));

app.get("/api/examples", (_req, res) => {
    res.json(EXAMPLES);
});

app.get("/api/example", async (req, res) => {
    const id = String(req.query.id ?? "").trim();
    if (!id) {
        res.status(400).json({ error: "example id is required" });
        return;
    }

    try {
        const result = await withAbap(() => callMeta(id));
        if (result.error) {
            res.status(400).json({ error: result.error });
            return;
        }
        res.json(result);
    } catch (error) {
        res.status(500).json({ error: error.message ?? String(error) });
    }
});

app.post("/api/generate", async (req, res) => {
    const example = String(req.body?.example ?? "").trim();
    const template = String(req.body?.template ?? "").trim();
    const rCnt = parseCount(req.body?.mv_r_cnt, 15);
    const cCnt = parseCount(req.body?.mv_c_cnt, 3);
    const bCnt = parseCount(req.body?.mv_b_cnt, 3);

    if (!example || !template) {
        res.status(400).json({ error: "example and template are required" });
        return;
    }

    try {
        const result = await withAbap(() => callGenerate({ example, template, rCnt, cCnt, bCnt }));
        if (result.error) {
            res.status(400).json({ error: result.error });
            return;
        }
        if (!result.buffer.length) {
            res.status(500).json({ error: "Generated file is empty" });
            return;
        }
        res.setHeader("Content-Type", result.mimetype);
        res.setHeader("Content-Disposition", `attachment; filename="${result.filename}"`);
        res.send(result.buffer);
    } catch (error) {
        res.status(500).json({ error: error.message ?? String(error) });
    }
});

const port = Number.parseInt(process.env.PORT ?? "3000", 10) || 3000;
app.listen(port, () => {
    console.log(`XTT demo UI: http://localhost:${port}`);
});
