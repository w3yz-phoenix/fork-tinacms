import { defineTinaTemplate } from "../../lib/tina.utils";

export const productListBlockDefaultItem = {
  title: "Urunler",
};

export const productListBlockSchema = defineTinaTemplate({
  name: "productList",
  label: "Product List",
  ui: {
    previewSrc: "/blocks/product-list/preview.png",
    defaultItem: {
      ...productListBlockDefaultItem,
    },
  },
  fields: [
    {
      type: "string",
      label: "Title",
      name: "title",
      description: "The title of the product list",
      required: true,
      isTitle: true,
    },
  ],
});
