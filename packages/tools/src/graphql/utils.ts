export const trimLines = (str: string) => {
  return str
    .split("\n")
    .map((l) => l.trim())
    .join("\n");
};

export const defineTemplate = (name: string, content: string) => {
  return {
    add: {
      content: trimLines(`
      /* template-start: ${name} */
      ${content}
      /* template-end: ${name} */
      `),
    },
  };
};
