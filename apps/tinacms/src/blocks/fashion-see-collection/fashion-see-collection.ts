import { imageField } from "../../fields/image";
import { linkField } from "../../fields/link";
import { defineTinaTemplate } from "../../lib/tina.utils";

export const seeCollectionBlockDefaultItem = {
  title: "See Collection",
  text: "See our latest collection of fashion items.",
};

export const seeCollectionBlockSchema = defineTinaTemplate({
  name: "seeCollection",
  label: "See Our Collection",
  ui: {
    previewSrc: "/blocks/see-collection/preview.png",
    defaultItem: {
      title: "Yeni ve Modern",
      title2: "2024",
      linkTitle: "Koleksiyonu Gör",
      items: [seeCollectionBlockDefaultItem],
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
      name: "title2",
      label: "Title2",
    },
    {
      type: "object",
      name: "photos",
      label: "photos",
      list: true,
      ui: {
        min: 2,
        max: 2,
        itemProps: (item: any) => {
          return {
            label: item?.alt,
            key: item?.image,
          };
        },
        defaultItem: {
          ...seeCollectionBlockDefaultItem,
        },
      },
      fields: [imageField as any],
    },
    linkField as any,
  ],
});
