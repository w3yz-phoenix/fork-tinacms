import { defineTinaTemplate } from "../../lib/tina.utils";

export const commentSliderBlockDefaultItem = {
  title: "Demo Title",
  titleDescription: "Demo Title Description",
  subtitle: "Demo Subtitle",
  subtitleDescription: "Demo Subtitle Description Text",
};

export const commentSliderBlockSchema = defineTinaTemplate({
  name: "commentSlider",
  label: "Comment Slider",
  ui: {
    previewSrc: "/blocks/comment-slider/preview.png",
    defaultItem: {
      items: [commentSliderBlockDefaultItem],
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
      name: "titleDescription",
      label: "Title Description",
    },

    {
      type: "object",
      label: "Comment Slider",
      name: "commentSlider",
      list: true,
      ui: {
        itemProps: (item: any) => {
          return {
            label: item?.avatarTitle,
            key: item?.src,
          };
        },
        defaultItem: {
          ...commentSliderBlockDefaultItem,
        },
      },
      fields: [
        {
          type: "string",
          name: "avatarTitle",
          label: "Avatar Title",
          isTitle: true,
          required: true,
        },
        {
          type: "string",
          name: "avatarDescription",
          label: "Avatar Description",
        },
        {
          type: "image",
          name: "src",
          label: "src",
          required: true,
        },
        {
          type: "string",
          name: "alt",
          label: "alt",
        },
        {
          type: "string",
          name: "subtitle",
          label: "Subtitle",
        },
        {
          type: "string",
          name: "subtitleDescription",
          label: "Subtitle Description",
        },
      ],
    },
  ],
});
