import { linkField } from "../../fields/link";
import { defineTinaTemplate } from "../../lib/tina.utils";

export const productBlockDefaultItem = {
  title: "Demo Title",
  subtitle: "Demo Subtitle",
  text: "Demo Text",
};

export const productBlockSchema = defineTinaTemplate({
  name: "product",
  label: "Product",
  ui: {
    previewSrc: "/blocks/product/preview.png",
    defaultItem: {
      title: "Product Title",
      subtitle: "Product Subtitle",
      items: [productBlockDefaultItem],
    },
  },
  fields: [
    linkField as any,
    {
      type: "object",
      label: "Products Category",
      name: "productsCategory",
      list: true,
      ui: {
        itemProps: (item: any) => {
          return {
            label: item?.alt,
            key: item?.image,
          };
        },
        max: 3,
        defaultItem: {
          ...productBlockDefaultItem,
        },
      },
      fields: [
        {
          type: "string",
          name: "categoryName",
          label: "Category Name",
          required: true,
        },
        {
          type: "object",
          label: "Products",
          name: "products",
          list: true,
          ui: {
            itemProps: (item: any) => {
              return {
                label: item?.alt,
                key: item?.image,
              };
            },
            max: 6,
            defaultItem: {
              ...productBlockDefaultItem,
            },
          },
          fields: [
            {
              type: "image",
              name: "image",
              label: "Image",
              required: true,
            },
            {
              type: "string",
              name: "productName",
              label: "Product Name",
              isTitle: true,
              required: true,
            },
            {
              type: "string",
              name: "productLink",
              label: "Product Link",
            },
          ],
        },
      ],
    },
  ],
});
