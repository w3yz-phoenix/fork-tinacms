import { type Collection } from "tinacms";
import { v5 } from "uuid";

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
      ui: {
        component: "hidden",
      },
    },
    {
      type: "string",
      name: "title",
      label: "Title",
      isTitle: true,
      required: true,
    },
    {
      type: "rich-text",
      name: "body",
      label: "Content",
      isBody: true,
    },
  ],
};
