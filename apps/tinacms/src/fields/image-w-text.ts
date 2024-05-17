export const imageWithTextField = {
  type: "object",
  name: "image",
  label: "image",
  fields: [
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
      required: true,
    },
    {
      type: "string",
      name: "title",
      label: "title",
      required: true,
    },
    {
      type: "string",
      name: "subtitle",
      label: "subtitle",
      required: true,
    },
  ],
} as const;
