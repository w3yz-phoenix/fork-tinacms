import { z } from "zod";

export const withZod = <
  ZodSchema extends z.ZodType,
  ZodSchemaProperties = z.TypeOf<ZodSchema>,
>(
  name: string,
  schema: ZodSchema,
  Component: React.FC<ZodSchemaProperties>
) => {
  const ReturnedComponent: React.FC<ZodSchemaProperties> = (
    props: ZodSchemaProperties
  ) => {
    const parseResult = schema.safeParse(props);
    if (!parseResult.success) {
      console.error(
        `withZod: ${name} component props validation failed:`,
        parseResult.error
      );
      return;
    }

    return <Component {...parseResult.data} />;
  };

  Object.defineProperty(ReturnedComponent, "name", {
    value: name,
    writable: false,
  });

  Object.defineProperty(ReturnedComponent, "displayName", {
    value: name,
    writable: false,
  });

  return ReturnedComponent;
};
