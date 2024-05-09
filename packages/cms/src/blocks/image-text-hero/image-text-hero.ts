import { defineTinaTemplate } from "../../lib/tina.utils";

export const imageTextHeroBlockDefaultItem = {
  title: "Here's Another Feature",
  text: "This is where you might talk about the feature, if this wasn't just filler text.",
};

export const imageTextHeroBlockSchema = defineTinaTemplate({
  name: "imageTextHero",
  label: "Image Text Hero",
  ui: {
    previewSrc: "/blocks/image-text-hero/preview.png",
    defaultItem: {
      title: "Image Text Hero Title",
      subtitle: "Image Text Hero Subtitle",
      items: [imageTextHeroBlockDefaultItem],
    },
  },
  fields: [
    {
      type: "string",
      name: "title",
      label: "Title",
      isTitle: true,
      required: true,
    },
    {
      type: "string",
      name: "subTitle",
      label: "SubTitle",
    },
    {
      type: "string",
      name: "description",
      label: "description",
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
    {
      type: "object",
      name: "link",
      label: "link",
      fields: [
        {
          type: "string",
          name: "href",
          label: "name",
          required: true,
        },
        {
          type: "string",
          name: "name",
          label: "name",
          required: true,
        },
      ],
    },
  ],
});
