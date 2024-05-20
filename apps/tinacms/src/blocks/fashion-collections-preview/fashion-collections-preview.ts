import { imageWithTextField } from "../../fields/image-w-text";
import { defineTinaTemplate } from "../../lib/tina.utils";

export const fashionCollectionsPreviewBlockDefaultItem = {
  title: "Yeni ve Modern",
  linkTitle: "Koleksiyonu Gör",
  linkCollection: "/shop",
  imageLink: "/shop",
};

export const FashionCollectionsPreviewBlockSchema = defineTinaTemplate({
  name: "FashionCollectionsPreview",
  label: "Fashion Collections Preview",
  ui: {
    previewSrc: "/blocks/fashion-collections-preview/preview.png",
    defaultItem: {
      ...fashionCollectionsPreviewBlockDefaultItem,
      items: [fashionCollectionsPreviewBlockDefaultItem],
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
      name: "linkTitle",
      label: "Link Title",
    },
    {
      type: "string",
      name: "linkCollection",
      label: "Link Collection",
    },
    {
      type: "object",
      name: "collectionPhotos",
      label: "Collection Photos",
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
          name: "imageLink",
          label: "Collection Link"
        }
      ],
    },
  ],
});
