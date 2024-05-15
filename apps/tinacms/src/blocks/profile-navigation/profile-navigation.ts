import { defineTinaTemplate } from "../../lib/tina.utils";

export const profileNavigationBlockDefaultItem = {
  title: "Here's Another Feature",
  text: "This is where you might talk about the feature, if this wasn't just filler text.",
};

export const profileNavigationBlockSchema = defineTinaTemplate({
  name: "profileNavigation",
  label: "Profile Navigation",
  ui: {
    previewSrc: "/blocks/profile-navigation/preview.png",
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
