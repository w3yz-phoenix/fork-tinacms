import { type TinaField, type Template } from "tinacms";

export const defineTinaField = <const T extends TinaField = TinaField>(
  field: T
) => field;

export const defineTinaTemplate = <const T extends Template = Template>(
  template: T
) => template;
