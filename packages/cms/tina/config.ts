import { defineConfig, LocalAuthProvider } from "tinacms";
import { PageCollection } from "../src/collections/page";
import { GlobalConfigCollection } from "../src/collections/global-config";

const isLocal = process.env.TINA_PUBLIC_IS_LOCAL === "true";

export default defineConfig({
  authProvider: isLocal ? new LocalAuthProvider() : new LocalAuthProvider(),

  build: {
    outputFolder: "admin",
    publicFolder: "public",
  },
  media: {
    tina: {
      mediaRoot: "uploads",
      publicFolder: "public",
    },
  },

  schema: {
    collections: [GlobalConfigCollection, PageCollection],
  },
});
