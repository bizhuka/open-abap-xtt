import { existsSync, readFileSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const envPath = fileURLToPath(new URL("../.env", import.meta.url));
if (existsSync(envPath)) {
    for (const line of readFileSync(envPath, "utf8").split(/\r?\n/)) {
        const trimmed = line.trim();
        if (!trimmed || trimmed.startsWith("#")) {
            continue;
        }
        const index = trimmed.indexOf("=");
        if (index < 1) {
            continue;
        }
        const key = trimmed.slice(0, index).trim();
        let value = trimmed.slice(index + 1).trim();
        if (
            (value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'"))
        ) {
            value = value.slice(1, -1);
        }
        if (process.env[key] === undefined) {
            process.env[key] = value;
        }
    }
}

if (process.env.VERIFY_ON_START === "1") {
    console.log("VERIFY_ON_START=1: running npm run verify");
    const result = spawnSync("npm", ["run", "verify"], {
        stdio: "inherit",
        shell: true,
    });
    if (result.status !== 0) {
        process.exit(result.status ?? 1);
    }
}

await import("./server.mjs");
