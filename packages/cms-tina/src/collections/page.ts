import { type Collection } from "tinacms";

export const PageCollection: Collection = {
  name: "page",
  label: "Page",
  path: "content/pages",
  format: "mdx",
  ui: {
    router: () => "/",
  },
  fields: [
    {
      type: "string",
      name: "title",
      label: "Title",
    },
  ],
};
