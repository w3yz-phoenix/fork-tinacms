import type { Collection } from "tinacms";

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
    // {
    //   name: "header",
    //   label: "Header",
    //   type: "object",
    //   ui: {
    //     visualSelector: true,
    //   }
    //   fields: [
    //     {
    //       name: "title",
    //       label: "Title",
    //       type: "string",
    //     },
    //     {
    //       name: "subtitle",
    //       label: "Subtitle",
    //       type: "string",
    //     },
    //   ],
    // },
  ],
};
