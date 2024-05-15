import { imageField } from "../../fields/image";
import { linkField } from "../../fields/link";
import { defineTinaTemplate } from "../../lib/tina.utils";

export const trioPhotoTextBlockDefaultItem = {
  title: "Trio Photo with Text",
  subtitle: "Trio Photo with Text Subtitle",
  description: "This is a trio photo with description block",
};

export const TrioPhotoTextBlockSchema = defineTinaTemplate({
  name: "TrioPhotoText",
  label: "Trio Photo Text",
  ui: {
    previewSrc: "/blocks/trio-photo-text/preview.png",
    defaultItem: {
      title: "Hero Slider Title",
      subtitle: "Hero Slider Subtitle",
      items: [trioPhotoTextBlockDefaultItem],
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
      type: "string",
      name: "description",
      label: "description",
    },
    linkField as any,
    {
      type: "object",
      name: "photos",
      label: "photos",
      list: true,
      ui: {
        max: 3,
        itemProps: (item: any) => {
          return {
            label: item?.alt,
            key: item?.image,
          };
        },
        defaultItem: {
          ...trioPhotoTextBlockDefaultItem,
        },
      },
      fields: [imageField as any],
    },
  ],
});
