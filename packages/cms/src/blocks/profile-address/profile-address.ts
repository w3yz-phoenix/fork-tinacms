import { defineTinaTemplate } from "../../lib/tina.utils";

export const profileAddressBlockDefaultItem = {
  title: "Here's Another Feature",
  text: "This is where you might talk about the feature, if this wasn't just filler text.",
};

export const profileAddressBlockSchema = defineTinaTemplate({
  name: "profileAddress",
  label: "Profile Address",
  ui: {
    previewSrc: "/blocks/profile-address/preview.png",
  },
  fields: [
    {
      type: "string",
      name: "mainTitle",
      label: "Main Title",
      isTitle: true,
      required: true,
    },
  ],
});
