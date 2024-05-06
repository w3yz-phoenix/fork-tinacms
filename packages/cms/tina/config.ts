import { defineConfig, LocalAuthProvider } from "tinacms";
import { GlobalConfigCollection, PageCollection } from "../exports/collections";

const isLocal = process.env.TINA_PUBLIC_IS_LOCAL === "true";

export default defineConfig({
  authProvider: isLocal ? new LocalAuthProvider() : new LocalAuthProvider(),

  // contentApiUrlOverride: "/api/tina/gql",

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
