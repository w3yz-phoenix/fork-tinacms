export const linkField = {
  type: "object",
  name: "link",
  label: "link",
  fields: [
    {
      type: "string",
      name: "href",
      label: "href",
      required: true,
    },
    {
      type: "string",
      name: "name",
      label: "name",
      required: true,
    },
  ],
} as const;
