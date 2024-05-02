import { Glob } from "bun";

const glob = new Glob("src/**/*.ts");
const files = [...glob.scanSync(".")];

await Bun.build({
  entrypoints: files,
  outdir: "./dist",
});
