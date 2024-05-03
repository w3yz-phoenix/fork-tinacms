import {
  UsernamePasswordAuthJSProvider,
  TinaUserCollection,
} from "tinacms-authjs/dist/tinacms";
import { defineConfig, LocalAuthProvider } from "tinacms";

import { GlobalConfigCollection, PageCollection } from "../src/collections";

const isLocal = process.env.TINA_PUBLIC_IS_LOCAL === "true";

export const tinaConfig = defineConfig({
  authProvider: isLocal
    ? new LocalAuthProvider()
    : new UsernamePasswordAuthJSProvider(),

  build: {
    publicFolder: "public",
    outputFolder: "admin",
  },
  media: {
    tina: {
      publicFolder: "public",
      mediaRoot: "uploads",
    },
  },
  schema: {
    collections: [TinaUserCollection, PageCollection, GlobalConfigCollection],
  },
});
