export const imageField = {
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
  ],
} as const;
