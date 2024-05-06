import { defineTinaTemplate } from "../../lib/tina.utils";

export const demoFeaturesBlockDefaultItem = {
  title: "Demo Title",
  subtitle: "Demo Subtitle",
  text: "Demo Text",
};

export const demoFeaturesBlockSchema = defineTinaTemplate({
  name: "demoFeatures",
  label: "Demo Features",
  ui: {
    previewSrc: "/blocks/demo-features/preview.png",
    defaultItem: {
      items: [demoFeaturesBlockDefaultItem],
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
          ...demoFeaturesBlockDefaultItem,
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
          label: "Subtitle",
          name: "subtitle",
          description: "Optional Subtitle",
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
