import { imageField } from "../../fields/image";
import { linkField } from "../../fields/link";
import { defineTinaTemplate } from "../../lib/tina.utils";

export const imageTextHeroBlockDefaultItem = {
  title: "Here's Another Feature",
  text: "This is where you might talk about the feature, if this wasn't just filler text.",
};

export const imageTextHeroBlockSchema = defineTinaTemplate({
  name: "imageTextHero",
  label: "Image Text Hero",
  ui: {
    previewSrc: "/blocks/image-text-hero/preview.png",
    defaultItem: {
      title: "Image Text Hero Title",
      subtitle: "Image Text Hero Subtitle",
      items: [imageTextHeroBlockDefaultItem],
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
    imageField as any,
    linkField as any,
  ],
});
