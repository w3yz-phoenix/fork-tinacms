import {
  Command,
  CompletionsCommand,
} from "https://deno.land/x/cliffy@v1.0.0-rc.4/command/mod.ts";
import { generate } from "./src/generate/mod.ts";

export const mainCommand = new Command()
  .name("t")
  .description("W3YZ Command Line Toolkit")
  .command("completions", new CompletionsCommand())
  .command("generate", generate);

await mainCommand.parse(Deno.args);
