import { defineTinaTemplate } from "../../lib/tina.utils";

export const profilePersonalInformationBlockDefaultItem = {
  title: "Here's Another Feature",
  text: "This is where you might talk about the feature, if this wasn't just filler text.",
};

export const profilePersonalInformationBlockSchema = defineTinaTemplate({
  name: "profilePersonalInformation",
  label: "Profile Personal Information",
  ui: {
    previewSrc: "/blocks/profile-personal-information/preview.png",
  },
  fields: [
    {
      type: "string",
      name: "mainTitle",
      label: "Main Title",
      isTitle: true,
      required: true,
    },
    {
      type: "string",
      name: "subTitle",
      label: "Sub Title",
    },
  ],
});
