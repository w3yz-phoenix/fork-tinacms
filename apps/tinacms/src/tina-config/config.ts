import { defineConfig, LocalAuthProvider } from "tinacms";
import {
  TinaUserCollection,
  UsernamePasswordAuthJSProvider,
} from "tinacms-authjs/dist/tinacms";

import { CustomPageCollection } from "../collections/custom-page";
import { GlobalConfigCollection } from "../collections/global-config";
import { PageCollection } from "../collections/page";
import { tinaEnvironment } from "../lib/environment";

export const tinaConfig = defineConfig({
  authProvider: tinaEnvironment.public.cms.isLocal
    ? new LocalAuthProvider()
    : new UsernamePasswordAuthJSProvider(),

  contentApiUrlOverride: tinaEnvironment.public.cms.graphql,
  localContentPath: tinaEnvironment.public.cms.contentRootPath,

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
    collections: [
      TinaUserCollection,
      GlobalConfigCollection,
      PageCollection,
      CustomPageCollection,
    ],
  },
});
