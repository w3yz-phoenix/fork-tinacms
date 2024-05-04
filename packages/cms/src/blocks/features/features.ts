import { defineTinaTemplate } from "../../lib/tina.utils";

export const featuresBlockDefaultItem = {
  title: "Here's Another Feature",
  text: "This is where you might talk about the feature, if this wasn't just filler text.",
};

export const featuresBlockSchema = defineTinaTemplate({
  name: "features",
  label: "Features",
  ui: {
    previewSrc: "/blocks/features/preview.png",
    defaultItem: {
      items: [featuresBlockDefaultItem],
    },
  },
  fields: [
    {
      type: "object",
      label: "Feature Items",
      name: "items",
      list: true,
      ui: {
        itemProps: (item: any) => {
          return {
            label: item?.title,
          };
        },
        defaultItem: {
          ...featuresBlockDefaultItem,
        },
      },
      fields: [
        {
          type: "string",
          label: "Title",
          name: "title",
        },
        {
          type: "string",
          label: "Text",
          name: "text",
          ui: {
            component: "textarea",
          },
        },
      ],
    },
  ],
});
