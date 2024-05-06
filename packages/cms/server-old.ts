import { Elysia } from "elysia";

new Elysia()
  .get("/admin", Bun.file("./public/admin/index.html"))
  .get("/admin/index.html", Bun.file("./public/admin/index.html"))
  .get("/blocks/:block/preview.png", ({ params }) =>
    Bun.file(`./src/blocks/${params.block}/preview.png`)
  )
  .get("/uploads/*", ({ path }) => {
    return Bun.file(`./public${path}`);
  })
  .get("/*", ({ redirect, path }) => {
    return fetch(`http://localhost:3000${path}`).then((res) => {
      if (res.status === 404) {
        return redirect("/admin");
      }
      return res;
    });
  })

  .onStart(({ server }) => {
    console.log(`Server is listening on ${new URL(`${server?.url}admin`)}`);
  })
  .listen(3200);
