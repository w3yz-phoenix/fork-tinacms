import type { z } from "zod";

export type ActionValidationErrorType<TSchema extends Zod.Schema> = {
  name: "ValidationError";
  fieldErrors: z.inferFlattenedErrors<TSchema>["fieldErrors"];
  message: string;
};

export class ValidationError<TSchema extends Zod.Schema> extends Error {
  fieldErrors: z.inferFlattenedErrors<TSchema>["fieldErrors"];

  constructor(private validationError: z.SafeParseError<TSchema>) {
    super("Validation error");
    this.name = "ValidationError";

    const fieldErrors = this.validationError.error.flatten()?.fieldErrors;
    this.fieldErrors = fieldErrors;
    this.message = Object.entries(fieldErrors)
      .map(([key, errors]) => {
        const errorArray = (
          Array.isArray(errors)
            ? errors
            : [typeof errors === "string" ? errors : "unknown-error"]
        ) as string[];

        return `${key}: ${errorArray.join(", ")}`;
      })
      .join("\n");
  }

  serialize(): ActionValidationErrorType<TSchema> {
    return {
      name: "ValidationError",
      fieldErrors: JSON.parse(JSON.stringify(this.fieldErrors)),
      message: this.message,
    } as const;
  }
}

export type ActionErrors<TSchema extends Zod.Schema> =
  | ActionValidationErrorType<TSchema>
  | { name: "UnknownError"; message: string };

export const initialActionState = { type: "initial", iteration: 0 } as const;
export const nonFormActionState = {
  type: "not-form-action",
  iteration: -1,
} as const;

export type ActionBody<
  TParams,
  TRet,
  TError extends ActionErrors<Zod.Schema<TParams>> = ActionErrors<
    Zod.Schema<TParams>
  >,
> = (
  params: TParams,
  previousState: ActionState<TParams, TError>
) => Promise<TRet | undefined>;

export type FormAction<
  TParams,
  TError extends ActionErrors<Zod.Schema<TParams>> = ActionErrors<
    Zod.Schema<TParams>
  >,
> = (
  ps: ActionState<TParams, TError>,
  formData: FormData
) => Promise<ActionState<TParams, TError>>;

type ActionState<T, E = unknown> =
  | typeof nonFormActionState
  | typeof initialActionState
  | {
      type: "success";
      state: T;
      error: null;
      iteration: number;
    }
  | {
      type: "error";
      error: E;
      iteration: number;
    };

export const createAction = <
  const TSchema extends Zod.Schema,
  const TRet,
  const TError extends ActionErrors<TSchema> = ActionErrors<TSchema>,
  const TParams = TSchema["_output"],
  const TOptionalParams = Partial<TParams>,
>(
  inputSchema: TSchema,
  actionFunction: ActionBody<TParams, TRet, TError>,
  parseJson = true
) => {
  const asAction: ActionBody<TOptionalParams, TRet> = async (
    inputParameters
  ) => {
    const validationResult = await inputSchema.spa(inputParameters);

    if (validationResult.success === false) {
      throw new ValidationError(validationResult);
    }

    const parameters: TParams = validationResult.data;

    return actionFunction(parameters, nonFormActionState);
  };

  const asFormAction: FormAction<TOptionalParams, TError> = async (
    previousState,
    formData
  ) => {
    try {
      const formDataEntries = [...formData.entries()].filter(
        ([k]) => !k.startsWith("$ACTION")
      );
      const parsedFormData = parseJson
        ? Object.fromEntries(
            formDataEntries.map(([k, v]) => [k, JSON.parse(v as string)])
          )
        : Object.fromEntries(formDataEntries);

      const validationResult = await inputSchema.spa(parsedFormData);

      if (validationResult.success === false) {
        throw new ValidationError(validationResult);
      }

      const parameters: TParams = validationResult.data;

      const response = await actionFunction(parameters, previousState as any);

      return {
        type: "success",
        iteration: previousState.iteration + 1,
        state: response,
      } as ActionState<TOptionalParams, TError>;
    } catch (error: unknown) {
      console.error(error);

      if (error instanceof ValidationError) {
        return {
          type: "error",
          iteration: previousState.iteration + 1,
          error: error.serialize(),
        };
      }

      return {
        type: "error",
        iteration: previousState.iteration + 1,
        error: (error as any)?.message ?? "Something went wrong",
      };
    }
  };

  return [asAction, asFormAction] as const;
};
