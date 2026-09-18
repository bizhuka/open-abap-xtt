import { existsSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import express from "express";

const rootDir = fileURLToPath(new URL(".", import.meta.url));
const initPath = join(rootDir, "output", "_init.mjs");
const publicDir = join(rootDir, "public");

if (!existsSync(initPath)) {
    throw new Error("Missing output/_init.mjs. Run npm run verify before starting the server.");
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

const textOf = (v) => (v == null ? "" : String(typeof v.get === "function" ? v.get() : v).trim());
const isAbapTrue = (v) => ["X", "true", "1"].includes(textOf(v));
const parseCount = (v, fallback) => {
    const n = Number.parseInt(String(v ?? ""), 10);
    return Number.isFinite(n) ? n : fallback;
};
const xstringToBuffer = (v) => {
    const hex = textOf(v).replace(/\s+/g, "");
    return hex ? Buffer.from(hex, "hex") : Buffer.alloc(0);
};

let abapQueue = Promise.resolve();
const withAbap = (work) => {
    const run = abapQueue.then(work, work);
    abapQueue = run.catch(() => undefined);
    return run;
};

patchDefaultDateTimeFormat();
const init = await import("./output/_init.mjs");
await init.initializeABAP();

const { Structure, TableFactory, Character, String: ABAPString, XString, Integer, Numc } = globalThis.abap.types;
const CL_OPEN_REPORT = globalThis.abap.Classes.ZCL_XTT_OPEN_REPORT;
const CL_DEMO = globalThis.abap.Classes.ZCL_XTT_DEMO;

if (!CL_OPEN_REPORT) {
    throw new Error("ZCL_XTT_OPEN_REPORT is not loaded. Run npm run verify.");
}

// Instantiate direct type if available on ZCL_XTT_DEMO, else create minimal structure
const newType = (fn, fallback) => {
    try {
        return typeof fn === "function" ? (fn.prototype ? new fn() : fn()) : fallback();
    } catch {
        return fallback();
    }
};

const makeScreenOpt = () => newType(CL_DEMO?.ts_screen_opt, () => new Structure({
    row_count:   new Character(1),
    colum_count: new Character(1),
    block_count: new Character(1),
    zip:         new Character(1),
    img_size:    new Character(1),
}));

const makeTemplates = () => newType(CL_DEMO?.tt_template, () => TableFactory.construct(
    new Structure({ objid: new Character(40) })
));

async function callGetAllExamples() {
    const instance = await new CL_OPEN_REPORT().constructor_();
    const rtExamples = await instance.get_all_examples();
    return rtExamples.array().map((row) => {
        const val = row.get();
        return {
            ind: textOf(val.ind),
            desc: textOf(val.desc)
        };
    });
}

async function callMeta(exampleId) {
    const instance = await new CL_OPEN_REPORT().constructor_();
    const esOpt = makeScreenOpt();
    const etTemplates = makeTemplates();
    const evError = new ABAPString();

    await instance.web_get_example_meta({
        iv_ind: new Character(3).set(exampleId),
        es_opt: esOpt,
        et_templates: etTemplates,
        ev_error: evError,
    });

    const error = textOf(evError);
    if (error) return { error };

    const opt = esOpt.get();
    return {
        row_count: isAbapTrue(opt.row_count),
        colum_count: isAbapTrue(opt.colum_count),
        block_count: isAbapTrue(opt.block_count),
        templates: etTemplates.array()
            .map((row) => ({ objid: textOf(row.get().objid) }))
            .filter((t) => t.objid),
    };
}

async function callGenerate({ example, template, rCnt, cCnt, bCnt }) {
    const instance = await new CL_OPEN_REPORT().constructor_();
    const evRaw = new XString();
    const evFilename = new ABAPString();
    const evMimetype = new ABAPString();
    const evError = new ABAPString();

    await instance.web_generate({
        iv_ind: new Character(3).set(example),
        iv_template: new ABAPString().set(template),
        iv_r_cnt: new Integer().set(rCnt),
        iv_c_cnt: new Numc(2).set(cCnt),
        iv_b_cnt: new Integer().set(bCnt),
        ev_raw: evRaw,
        ev_filename: evFilename,
        ev_mimetype: evMimetype,
        ev_error: evError,
    });

    const error = textOf(evError);
    if (error) return { error };

    return {
        buffer: xstringToBuffer(evRaw),
        filename: textOf(evFilename) || "no_file_name.bin",
        mimetype: textOf(evMimetype) || "application/octet-stream",
    };
}

const app = express();
app.use(express.json({ limit: "1mb" }));
app.use(express.urlencoded({ extended: false }));
app.use(express.static(publicDir));

app.get("/api/examples", async (_req, res) => {
    try {
        const list = await withAbap(() => callGetAllExamples());
        res.json(list);
    } catch (error) {
        res.status(500).json({ error: error.message ?? String(error) });
    }
});

app.get("/api/example", async (req, res) => {
    const ind = String(req.query.ind ?? "").trim();
    if (!ind) return res.status(400).json({ error: "example ind is required" });

    try {
        const result = await withAbap(() => callMeta(ind));
        if (result.error) return res.status(400).json({ error: result.error });
        res.json(result);
    } catch (error) {
        res.status(500).json({ error: error.message ?? String(error) });
    }
});

const generate = async (req, res) => {
    const params = req.method === "GET" ? req.query : req.body;
    
    const example = String(params?.example ?? "").trim();
    const template = String(params?.template ?? "").trim();
    const rCnt = parseCount(params?.mv_r_cnt, 15);
    const cCnt = parseCount(params?.mv_c_cnt, 3);
    const bCnt = parseCount(params?.mv_b_cnt, 3);

    if (!example || !template) {
        return res.status(400).json({ error: "example and template are required" });
    }

    try {
        const result = await withAbap(() => callGenerate({ example, template, rCnt, cCnt, bCnt }));
        if (result.error) return res.status(400).json({ error: result.error });
        if (!result.buffer.length) return res.status(500).json({ error: "Generated file is empty" });

        res.setHeader("Content-Type", result.mimetype);
        res.setHeader("Content-Disposition", `attachment; filename="${result.filename}"`);
        res.send(result.buffer);
    } catch (error) {
        res.status(500).json({ error: error.message ?? String(error) });
    }
};

app.get("/api/generate", generate);
app.post("/api/generate", generate);

app.use((error, _req, res, _next) => {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
});

export default app;
