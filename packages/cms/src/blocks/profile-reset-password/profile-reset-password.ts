import { defineTinaTemplate } from "../../lib/tina.utils";

export const profileResetPasswordBlockDefaultItem = {
  title: "Here's Another Feature",
  text: "This is where you might talk about the feature, if this wasn't just filler text.",
};

export const profileResetPasswordBlockSchema = defineTinaTemplate({
  name: "profileResetPassword",
  label: "Profile Reset Password",
  ui: {
    previewSrc: "/blocks/profile-reset-password/preview.png",
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
