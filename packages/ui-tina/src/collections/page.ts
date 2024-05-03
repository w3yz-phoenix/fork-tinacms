/* eslint-disable unicorn/prefer-module */
/* eslint-disable @typescript-eslint/no-var-requires */
import { type Collection } from "tinacms";
import { v5 } from "uuid";
import { schema as blockFeaturesSchema } from "@w3yz/block-features/schema";

export const PageCollection: Collection = {
  name: "page",
  label: "Page",
  path: "content/pages",
  format: "mdx",
  ui: {
    router: () => "/",
    beforeSubmit: async ({ values }) => {
      return {
        ...values,
        uuid: values.uuid ?? v5((values.title ?? "") as string, v5.URL),
      };
    },
  },
  fields: [
    {
      type: "string",
      name: "uuid",
      label: "ID",
      uid: true,
      required: true,
      indexed: true,
      ui: {
        component: "hidden",
      },
    },
    {
      type: "string",
      label: "Title",
      name: "title",
      description:
        "The title of the page. This is used to display the title in the CMS",
      isTitle: true,
      required: true,
    },
    {
      type: "object",
      list: true,
      name: "blocks",
      label: "Sections",
      ui: {
        visualSelector: true,
      },
      templates: [blockFeaturesSchema],
    },
  ],
};
