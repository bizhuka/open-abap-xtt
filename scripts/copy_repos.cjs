const fs = require("fs");
const path = require("path");
const os = require("os");
const { execFileSync } = require("child_process");

const ROOT = path.resolve(__dirname, "..");
const SRC = path.join(ROOT, "src");

const REPOS = [
    {
        name: "eui",
        url: "https://github.com/bizhuka/eui.git",
        marker: "zif_eui_manager.intf.abap",
        exclude: [
            "**/package.devc.xml",
            "zcl_eui_alv*",
            "zcl_eui_memo*",
            "zcl_eui_screen*",
            "zcl_eui_tree*",
            "zfg_eui_screen.fugr.*",
            "zeui_dynamic_screen_events.prog.*",
            "demo/*",
            "ext/*"
        ]
    },
    {
        name: "xtt",
        url: "https://github.com/bizhuka/xtt.git",
        marker: "zcl_xtt.clas.abap",
        exclude: [
            "**/package.devc.xml",
            "demo/zxtt_break_point*",
            "demo/z_xtt_demo_n060.prog.*",
            "demo/z_xtt_demo_n100.prog.*"
        ]
    }
];

function copyRepo({ name, url, marker, exclude }) {
    const targetDir = path.join(SRC, name);
    const markerPath = path.join(targetDir, marker);

    if (fs.existsSync(markerPath)) {
        console.log(`${name}: already installed`);
        return;
    }

    const temp = fs.mkdtempSync(
        path.join(os.tmpdir(), `${name.toLowerCase()}-`)
    );

    try {
        console.log(`${name}: cloning...`);

        execFileSync(
            "git",
            ["clone", "--depth", "1", url, temp],
            { stdio: "inherit" }
        );

        const source = path.join(temp, "src");

        if (!fs.existsSync(source)) {
            throw new Error(`${name}: src directory not found`);
        }

        copyDir(source, targetDir);
        removeExcluded(targetDir, exclude);

        console.log(`${name}: installed`);
    } finally {
        fs.rmSync(temp, { recursive: true, force: true });
    }
}

function copyDir(source, target) {
    fs.mkdirSync(target, { recursive: true });

    for (const entry of fs.readdirSync(source, { withFileTypes: true })) {
        const src = path.join(source, entry.name);
        const dst = path.join(target, entry.name);

        if (entry.isDirectory()) {
            copyDir(src, dst);
        } else {
            fs.copyFileSync(src, dst);
        }
    }
}

function removeExcluded(root, patterns) {
    for (const file of walk(root)) {
        const relative = path.relative(root, file).replaceAll("\\", "/");

        if (patterns.some(pattern => match(relative, pattern))) {
            fs.rmSync(file, { recursive: true, force: true });
            console.log(`removed: ${relative}`);
        }
    }
}

function* walk(dir) {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
        const fullPath = path.join(dir, entry.name);

        if (entry.isDirectory()) {
            yield* walk(fullPath);
        } else {
            yield fullPath;
        }
    }
}

function match(value, pattern) {
    const regex = new RegExp(
        "^" +
        pattern
            .replace(/[.+^${}()|[\]\\]/g, "\\$&")
            .replaceAll("**/", "(.*/)?")
            .replaceAll("*", ".*") +
        "$"
    );

    return regex.test(value);
}

for (const repo of REPOS) {
    copyRepo(repo);
}

const PATCH_DIR = path.join(SRC, "patch");
const NODE_MODULES_DIR = path.join(ROOT, "node_modules");

if (fs.existsSync(PATCH_DIR)) {
    console.log("Applying patches...");
    copyDir(PATCH_DIR, NODE_MODULES_DIR);
    console.log("Patches applied.");
}
