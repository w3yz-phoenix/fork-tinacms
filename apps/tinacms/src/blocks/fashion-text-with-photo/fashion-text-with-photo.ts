import { defineTinaTemplate } from "../../lib/tina.utils";

export const fashionTextWithPhotoBlockDefaultItem = {
  title: "2024 Yaz Sezonu",
  subTitle: "Kadın Mayo, Kadın Bikini, Bikini Üstü, Bikini Altı, Plaj Elbisesi, Pareo Modelleri",
  imageAlt: "Shop"
};

export const FashionTextWithPhotoBlockSchema = defineTinaTemplate({
  name: "FashionTextWithPhoto",
  label: "Fashion Text With Photo",
  ui: {
    previewSrc: "/blocks/fashion-text-with-photo/preview.png",
    defaultItem: {
      ...fashionTextWithPhotoBlockDefaultItem,
      items: [fashionTextWithPhotoBlockDefaultItem],
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
      label: "Sub Title",
    },
    {
      type: "boolean",
      name: "isReversed",
      label: "Reverse",
    },
    {
      type: "image",
      name: "photo",
      label: "Image",
    },
    {
      type: "string",
      name: "imageAlt",
      label: "Alt",
    },
  ],
});
