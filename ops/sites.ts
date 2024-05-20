import { Command } from "https://deno.land/x/cliffy@v1.0.0-rc.4/command/mod.ts";
import * as path from "https://deno.land/std@0.224.0/path/mod.ts";
import { expandGlob } from "https://deno.land/std@0.92.0/fs/mod.ts";
import jsYaml from "npm:js-yaml";

const currentDir = path.dirname(path.fromFileUrl(import.meta.url));
const glob = path.resolve(currentDir, "../../live/sites/**/w3yz.yaml");

await new Command()
  .name("sites")
  .description("Commands for sites")
  .action(async (params) => {
    const sites = [];
    for await (const file of expandGlob(glob)) {
      const yamlContent = await Deno.readTextFile(file.path);
      const manifest = jsYaml.load(yamlContent);
      const site = {
        ...manifest,
        mainDomain: manifest.domains.find((d: any) => d.type === "builtin"),
      };
      sites.push(site);
    }

    console.log(JSON.stringify(sites));
  })
  .parse(Deno.args);
