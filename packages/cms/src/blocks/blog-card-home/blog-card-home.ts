import { defineTinaTemplate } from "../../lib/tina.utils";

export const blogCardHomeBlockDefaultItem = {
  title: "Here's Another Feature",
  text: "This is where you might talk about the feature, if this wasn't just filler text.",
};

export const blogCardHomeBlockSchema = defineTinaTemplate({
  name: "blogCardHome",
  label: "Blog Card Home",
  ui: {
    previewSrc: "/blocks/blog-card-home/preview.png",
  },
  fields: [
    {
      type: "string",
      name: "mainTitle",
      label: "Main Title",
      isTitle: true,
      required: true,
    },
    {
      type: "object",
      name: "blogCards",
      label: "Blog Cards",
      list: true,
      fields: [
        {
          type: "string",
          name: "blogTitle",
          label: "Blog Title",
          isTitle: true,
          required: true,
        },
        {
          type: "string",
          name: "description",
          label: "description",
        },
        {
          type: "string",
          name: "link",
          label: "link",
          required: true,
        },
        {
          type: "object",
          name: "image",
          label: "image",
          fields: [
            {
              type: "image",
              name: "src",
              label: "src",
              required: true,
            },
            {
              type: "string",
              name: "alt",
              label: "alt",
              required: true,
            },
          ],
        },
      ],
    },
  ],
});
