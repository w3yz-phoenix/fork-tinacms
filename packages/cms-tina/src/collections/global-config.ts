import type { Collection } from "tinacms";

export const GlobalConfigCollection: Collection = {
  label: "Global Configurations",
  name: "globalConfig",
  path: "content/global-config",
  format: "yml",
  ui: {
    global: true,
  },
  fields: [
    {
      type: "string",
      name: "globalTitle",
      label: "Global Title",
    },
  ],
};
