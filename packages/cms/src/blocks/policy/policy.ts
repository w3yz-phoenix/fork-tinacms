import { defineTinaTemplate } from "../../lib/tina.utils";

export const policyBlockDefaultItem = {
  title: "Here's Another Feature",
  text: "This is where you might talk about the feature, if this wasn't just filler text.",
};

export const policyBlockSchema = defineTinaTemplate({
  name: "Policy",
  label: "Policy",
  ui: {
    previewSrc: "/blocks/blog-card-home/preview.png",
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
    {
      type: "string",
      name: "description",
      label: "Description",
    },
    {
      type: "object",
      label: "Policies Names",
      name: "policiesNames",
      list: true,
      ui: {
        itemProps: (item: any) => {
          return {
            label: item?.alt,
            key: item?.image,
          };
        },
        defaultItem: {
          ...policyBlockDefaultItem,
        },
      },
      fields: [
        {
          type: "string",
          name: "policyName",
          label: "Policy Name",
          isTitle: true,
          required: true,
        },
      ],
    },
    {
      type: "object",
      label: "Policies",
      name: "policies",
      list: true,
      ui: {
        itemProps: (item: any) => {
          return {
            label: item?.alt,
            key: item?.image,
          };
        },
        defaultItem: {
          ...policyBlockDefaultItem,
        },
      },
      fields: [
        {
          type: "string",
          name: "policyTitle",
          label: "Policy Title",
          isTitle: true,
          required: true,
        },
        {
          type: "string",
          name: "policyDescription",
          label: "Policy Description",
          required: true,
        },
      ],
    },
  ],
});
