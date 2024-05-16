/* eslint-disable import/no-named-as-default-member */
/* eslint-disable unicorn/prefer-module */
import express from "express";
import { createProxyMiddleware } from "http-proxy-middleware";

const app = express();

app.get("/admin", (req, res) => {
  res.sendFile("public/admin/index.html", { root: __dirname });
});
app.get("/admin/index.html", (req, res) => {
  res.sendFile("public/admin/index.html", { root: __dirname });
});

app.use(
  "/api/tina/gql",
  createProxyMiddleware({
    target: "http://localhost:4001",
    changeOrigin: false,
    pathRewrite: {
      ".*": "/graphql",
    },
  })
);

app.use(
  "/",
  createProxyMiddleware({
    target: "http://localhost:3200/",
    changeOrigin: false,
  })
);

app.listen(3000, () => {
  console.log(`Server is listening on http://localhost:3000/admin`);
});
