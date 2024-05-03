import type { Collection } from "tinacms";

import { PageCollection } from "./page";

export const defaultGlobalConfig = "main.yml";

export const GlobalConfigCollection: Collection = {
  label: "Global Configurations",
  name: "globalConfig",
  path: "content/global-config",
  format: "yml",
  ui: {
    allowedActions: {
      create: false,
      delete: false,
    },
    global: true,
    router: () => "/",
  },
  fields: [
    {
      name: "header",
      label: "Header",
      type: "object",
      fields: [
        {
          name: "logo",
          label: "Logo",
          type: "image",
        },
        {
          type: "object",
          list: true,
          name: "links",
          label: "Links",
          ui: {
            itemProps: (item) => {
              return {
                key: item.label,
                label: item.label,
              };
            },
            defaultItem: () => ({
              label: "Isimsiz",
              page: "content/pages/coming-soon.mdx",
            }),
          },
          fields: [
            {
              name: "label",
              label: "Label",
              type: "string",
            },
            {
              name: "page",
              label: "Page",
              type: "reference",
              collections: [PageCollection.name],
            },
          ],
        },
      ],
    },
  ],
};
