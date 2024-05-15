import { defineTinaTemplate } from "../../lib/tina.utils";

export const blogCardSliderBlockDefaultItem = {
  title: "Here's Another Feature",
  text: "This is where you might talk about the feature, if this wasn't just filler text.",
};

export const blogCardSliderBlockSchema = defineTinaTemplate({
  name: "blogCardSlider",
  label: "Blog Card Slider",
  ui: {
    previewSrc: "/blocks/blog-card-slider/preview.png",
  },
  fields: [
    {
      type: "string",
      name: "Title",
      label: "Title",
      required: true,
    },
    {
      type: "object",
      name: "blogCardSlider",
      label: "Blog Cards Slider",
      list: true,
      fields: [
        {
          type: "string",
          name: "description",
          label: "description",
          required: true,
        },
        {
          type: "string",
          name: "link",
          label: "link",
          required: true,
        },
        {
          type: "datetime",
          name: "date",
          label: "date",
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
