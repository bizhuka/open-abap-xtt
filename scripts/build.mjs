import { rm, readdir, copyFile, readFile, writeFile } from "node:fs/promises";
import { spawn } from "node:child_process";

const command = process.platform === "win32"
    ? "node_modules\\.bin\\abap_transpile.cmd"
    : "node_modules/.bin/abap_transpile";

await rm(new URL("../output/", import.meta.url), { recursive: true, force: true });

const child = spawn(command, ["abap_transpile.json"], {
    stdio: "inherit",
    shell: process.platform === "win32",
});

await new Promise((resolve, reject) => {
    child.on("error", reject);
    child.on("exit", async (code) => {
        if (code === 0) {
            try {
                const srcDir = new URL("../src/xtt/demo/", import.meta.url);
                const outDir = new URL("../output/", import.meta.url);
                const files = await readdir(srcDir);
                for (const file of files) {
                    if (file.startsWith("zxxt_demo_") && file.includes(".w3mi.data.")) {
                        await copyFile(new URL(file, srcDir), new URL(file, outDir));
                    }
                }

                // // https://github.com/abaplint/transpiler/issues/1796
                // const locals = new URL("zcl_xtt_xml_base.clas.locals.mjs", outDir);
                // const src = await readFile(locals, "utf8");
                // await writeFile(locals, src.replaceAll(
                //     `.FRIENDS_ACCESS_INSTANCE["do_merge"]`,
                //     `.FRIENDS_ACCESS_INSTANCE.SUPER["do_merge"]`
                // ));
                resolve();
            } catch (err) {
                reject(err);
            }
            return;
        }

        reject(new Error(`ABAP transpilation exited with code ${code}`));
    });
});