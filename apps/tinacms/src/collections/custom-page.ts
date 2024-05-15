import { type Collection } from "tinacms";

import { defineTinaTemplate } from "../lib/tina.utils";

export const rotatingTextTemplate = defineTinaTemplate({
  name: "RotatingText",
  label: "Rotating Text",
  fields: [
    {
      type: "string",
      label: "Content",
      name: "children",
      required: true,
      ui: {
        component: "textarea",
      },
    },
  ],
});

export const CustomPageCollection: Collection = {
  name: "customPage",
  label: "Custom Page",
  path: "content/custom-pages",
  format: "mdx",
  ui: {
    router: ({ document }) => `/custom/${document._sys.breadcrumbs.join("/")}`,
  },
  fields: [
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
      type: "rich-text",
      label: "Body",
      name: "body",
      description: "The main content of the page",
      isBody: true,
      required: true,
      templates: [rotatingTextTemplate],
    },
  ],
};
