import { type Collection } from "tinacms";

import { heroSliderBlockSchema } from "../blocks/hero-slider/hero-slider";
import { featuresBlockSchema } from "../blocks/features/features";
import { productListBlockSchema } from "../blocks/product-list/product-list";
import { imageTextHeroBlockSchema } from "../blocks/image-text-hero/image-text-hero";
import { blogCardHomeBlockSchema } from "../blocks/blog-card-home/blog-card-home";

export const PageCollection: Collection = {
  name: "page",
  label: "Page",
  path: "content/pages",
  format: "mdx",
  ui: {
    router: ({ document }) => `/${document._sys.breadcrumbs.join("/")}`,
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
      type: "object",
      list: true,
      name: "blocks",
      label: "Sections",
      ui: {
        visualSelector: true,
      },
      templates: [
        featuresBlockSchema,
        heroSliderBlockSchema,
        productListBlockSchema,
        imageTextHeroBlockSchema,
        blogCardHomeBlockSchema,
      ],
    },
  ],
};
