"use server";
import { publicEnvironment } from "@@ui/core/lib/environment";
import { cookies, headers } from "next/headers";

import type { z } from "zod";

export const setCookie = (name: string, value?: string) => {
  if (!value) {
    cookies().delete(name);
    return;
  }

  cookies().set(name, value, {
    secure: publicEnvironment.https,
    sameSite: "lax",
    httpOnly: true,
    maxAge: 60 * 60 * 24 * 365 * 10,
  });
};

export const getCookie = (name: string) => {
  return cookies().get(name)?.value;
};

export async function getIPAddress() {
  return headers().get("x-forwarded-for");
}

type ActionState<T> = {
  success: boolean;
  message: T;
  iteration?: number;
};

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
  async (ps: State, formData: FormData) => {
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
        success: true,
        message: response,
      };
    } catch (error: unknown) {
      console.error(error);

      return {
        success: false,
        message: (error as any)?.message ?? "Something went wrong",
      };
    }
  };
