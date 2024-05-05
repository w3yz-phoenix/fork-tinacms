await Bun.build({
  entrypoints: ["./src/styles/globals.css", "./src/ui/button.tsx"],
  outdir: "./dist",
});
