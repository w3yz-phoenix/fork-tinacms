import {
  UsernamePasswordAuthJSProvider,
  TinaUserCollection,
} from "tinacms-authjs/dist/tinacms";
import { defineStaticConfig, LocalAuthProvider } from "tinacms";

import { GlobalConfigCollection, PageCollection } from "@w3yz/ui-tina";

const isLocal = process.env.TINA_PUBLIC_IS_LOCAL === "true";

export default defineStaticConfig({
  authProvider: isLocal
    ? new LocalAuthProvider()
    : new UsernamePasswordAuthJSProvider(),
  contentApiUrlOverride: "/api/tina/gql",
  build: {
    publicFolder: "public",
    outputFolder: "admin",
  },
  media: {
    tina: {
      mediaRoot: "uploads",
      publicFolder: "public",
      static: true,
    },
  },
  schema: {
    collections: [TinaUserCollection, PageCollection, GlobalConfigCollection],
  },
});
