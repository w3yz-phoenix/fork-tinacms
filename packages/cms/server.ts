import { Elysia } from "elysia";

new Elysia()
  .get("/admin", Bun.file("./public/admin/index.html"))
  .get("/admin/index.html", Bun.file("./public/admin/index.html"))
  .get("/blocks/:block/preview.png", ({ params }) =>
    Bun.file(`./src/blocks/${params.block}/preview.png`)
  )
  .get("/preview/*", ({ redirect, path }) => {
    return redirect(`http://localhost:3000" + ${path}`, 301);
  })
  .get("/*", ({ path }) => {
    console.log("path:", path);
    return Bun.file(`./public${path}`);
  })
  .onStart(({ server }) => {
    console.log(`Server is listening on ${new URL(`${server?.url}admin`)}`);
  })
  .listen(3200);
