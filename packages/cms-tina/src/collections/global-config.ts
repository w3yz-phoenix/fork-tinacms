import type { Collection } from "tinacms";

export const GlobalConfigCollection: Collection = {
  label: "Global Configurations",
  name: "global_config",
  path: "content/global_config",
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
