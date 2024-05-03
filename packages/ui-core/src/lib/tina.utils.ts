export { tinaField } from "tinacms/dist/react";

import { type TinaField } from "tinacms";

export const defineTinaField = <T extends TinaField = TinaField>(field: T) =>
  field;
