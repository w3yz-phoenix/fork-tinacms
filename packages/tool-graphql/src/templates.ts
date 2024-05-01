import { defineTemplate, trimLines } from "./utils";

export const eslintDisable = defineTemplate(
  "disable-eslint",
  `/* eslint-disable */`
);

export const customScalars = defineTemplate(
  "common-scalars",
  `import type { CustomScalars } from '@w3yz/types';`
);
