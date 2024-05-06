import { defineTinaTemplate } from "../../lib/tina.utils";

export const heroSliderBlockDefaultItem = {
  title: "Demo Title",
  subtitle: "Demo Subtitle",
  text: "Demo Text",
};

export const heroSliderBlockSchema = defineTinaTemplate({
  name: "heroSlider",
  label: "Hero Slider",
  ui: {
    previewSrc: "/blocks/hero-slider/preview.png",
    defaultItem: {
      title: "Hero Slider Title",
      subtitle: "Hero Slider Subtitle",
      items: [heroSliderBlockDefaultItem],
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
      name: "subtitle",
      label: "Subtitle",
    },
    {
      type: "object",
      label: "Slider Images",
      name: "images",
      list: true,
      ui: {
        itemProps: (item: any) => {
          return {
            label: item?.image,
          };
        },
        defaultItem: {
          ...heroSliderBlockDefaultItem,
        },
      },
      fields: [
        {
          type: "string",
          name: "alt",
          label: "Alt Text",
          required: true,
        },
        {
          type: "image",
          name: "image",
          label: "Image",
          isTitle: true,
          required: true,
        },
      ],
    },
  ],
});
