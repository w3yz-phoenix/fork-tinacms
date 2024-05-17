import { imageWithTextField } from "../../fields/image-w-text";
import { linkField } from "../../fields/link";
import { defineTinaTemplate } from "../../lib/tina.utils";

export const fashionTrioPhotoTextBlockDefaultItem = {
  title: "Fashion Trio Photo with Text",
  subtitle: "Fashion Trio Photo with Text Subtitle",
  description: "This is a trio photo with description block",
};

export const FashionTrioPhotoTextBlockSchema = defineTinaTemplate({
  name: "FashionTrioPhotoText",
  label: "Fashion Trio Photo Text",
  ui: {
    previewSrc: "/blocks/fashion-trio-photo-text/preview.png",
    defaultItem: {
      title: "Yaratıcılık özgür bırakılmış bir zihindir.",
      subTitle:
        "İşleri basit, sezgisel ve kolay hale getirmeyi seviyoruz. Ustalıkla hazırlıyoruz.",
      items: [fashionTrioPhotoTextBlockDefaultItem],
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
      type: "object",
      name: "photos",
      label: "photos",
      list: true,
      ui: {
        min: 3,
        max: 3,
        itemProps: (item: any) => {
          return {
            label: item?.alt,
            key: item?.image,
          };
        },
        defaultItem: {
          ...fashionTrioPhotoTextBlockDefaultItem,
        },
      },
      fields: [imageWithTextField as any],
    },
  ],
});
