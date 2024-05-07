import type { z } from "zod";

export type FieldErrors<
  Fields extends Record<string, unknown> = Record<string, unknown>,
> = {
  [P in Fields extends any ? keyof Fields : never]?: string[] | undefined;
};

export class ValidationError<
  Fields extends Record<string, unknown> = Record<string, unknown>,
> extends Error {
  fieldErrors: FieldErrors<Fields>;

  constructor(private validationError: z.SafeParseError<Fields>) {
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
}

type ActionState<T, E = unknown> =
  | { state: "initial"; iteration: 0 }
  | {
      state: "success";
      data: T;
      error: null;
      iteration: number;
    }
  | {
      state: "error";
      error: E;
      iteration: number;
    };

export const initialActionState = { state: "initial", iteration: 0 } as const;

export const createAction =
  <
    T extends z.Schema,
    AF,
    Parameters = z.infer<T>,
    RT = AF extends (params: Parameters, state: infer U) => Promise<infer U>
      ? U
      : never,
    State = ActionState<RT>,
  >(
    inputSchema: T,
    actionFunction: AF & ((parameters: Parameters, ps: State) => Promise<RT>)
  ) =>
  async (ps: State, formData: FormData): Promise<State> => {
    try {
      const validationResult = await inputSchema.spa(
        Object.fromEntries(formData)
      );

      if (validationResult.success === false) {
        throw new ValidationError(validationResult);
      }

      const parameters = validationResult.data as Parameters;

      const response = await actionFunction(parameters, ps);

      return {
        ...ps,
        success: true,
        data: response,
      };
    } catch (error: unknown) {
      console.error(error);

      return {
        ...ps,
        success: false,
        error: (error as any)?.message ?? "Something went wrong",
      };
    }
  };
