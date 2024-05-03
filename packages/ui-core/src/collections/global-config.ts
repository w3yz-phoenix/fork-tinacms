import type { Collection } from "tinacms";

import { getIconSchema } from "../components";

export const defaultGlobalConfig = "main.yml";

export const GlobalConfigCollection: Collection = {
  label: "Global Configurations",
  name: "globalConfig",
  path: "content/global-config",
  format: "yml",
  ui: {
    global: true,
    router: () => "/",
  },
  fields: [
    {
      // FIXME: Delete me
      type: "string",
      name: "globalTitle",
      label: "Global Title",
    },
    getIconSchema(),
  ],
};
