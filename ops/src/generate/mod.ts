import { Command } from "https://deno.land/x/cliffy@v1.0.0-rc.4/command/mod.ts";
import { sites } from "./sites.ts";
import { environment } from "./environment.ts";

export const generate = new Command()
  .name("generate")
  .description("Generator commands")
  .command("sites", sites)
  .command("environment", environment);
