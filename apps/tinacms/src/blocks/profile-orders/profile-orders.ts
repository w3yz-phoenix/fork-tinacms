import { defineTinaTemplate } from "../../lib/tina.utils";

export const profileOrdersBlockDefaultItem = {
  title: "Here's Another Feature",
  text: "This is where you might talk about the feature, if this wasn't just filler text.",
};

export const profileOrdersBlockSchema = defineTinaTemplate({
  name: "profileOrders",
  label: "Profile Orders",
  ui: {
    previewSrc: "/blocks/profile-orders/preview.png",
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
