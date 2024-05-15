import { defineTinaTemplate } from "../../lib/tina.utils";
import { imageField } from "../../fields/image";

export const discountBlockDefaultItem = {
  title: "Here's Discounted Prices!",
  text: "This is a sample text. You can edit this text by clicking on it.",
};

export const discountBlockSchema = defineTinaTemplate({
  name: "discounts",
  label: "Discounts",
  ui: {
    previewSrc: "/blocks/discount/preview.png",
    defaultItem: {
      items: [discountBlockDefaultItem],
    },
  },
  fields: [
    {
      type: "object",
      label: "Discount Items",
      name: "items",
      list: true,
      ui: {
        max: 3,
        itemProps: (item: any) => {
          return {
            label: item?.title,
          };
        },
        defaultItem: {
          ...discountBlockDefaultItem,
        },
      },
      fields: [
        {
          type: "string",
          label: "Discount Ratio",
          name: "discountRatio",
        },
        {
          type: "string",
          label: "Title",
          name: "title",
        },
        {
          name: "link",
          label: "Link",
          type: "string",
        },
        imageField as any,
      ],
    },
  ],
});
