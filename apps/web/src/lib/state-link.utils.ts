import { z } from "zod";

export const createQueryStringLinkGenerator =
  <ZodSchema extends z.ZodType, ZodSchemaProperties = z.TypeOf<ZodSchema>>(
    pathname: string,
    schema: ZodSchema
  ) =>
  (
    previousState: ZodSchemaProperties | null | undefined,
    stateUpdate: Partial<ZodSchemaProperties>
  ) => {
    const nextState = schema.parse({
      ...(previousState ?? ({} as any)),
      ...stateUpdate,
    });

    let fullPathname = pathname;
    const searchParameters = new URLSearchParams();
    for (const [key, value] of Object.entries(nextState)) {
      searchParameters.set(key, String(value));
      fullPathname = fullPathname.replace(`[${key}]`, String(value));
    }

    const search = searchParameters.toString();

    return `${fullPathname}?${search}`;
  };
