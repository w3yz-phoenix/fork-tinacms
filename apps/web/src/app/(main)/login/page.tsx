/* eslint-disable unicorn/consistent-function-scoping */
import { useCheckoutEmailUpdateMutation } from "@w3yz/ecom/api";
import { getStringIfNotEmpty, invariant, safeJsonParse } from "@w3yz/tools/lib";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";

import { setCookie } from "#web/lib/actions/actions.server";
import {
  getCurrentCheckout,
  revalidateCheckout,
} from "#web/lib/checkout/checkout.query";

import { LoginForm } from "./form";
import { LoginFormSchema, type LoginFormType } from "./schemas";
import { saleorAuthClient } from "./auth-client";

export default async function LoginPage() {
  const existingFormValues = {
    email: "",
    password: "",
  };

  async function submitLoginForm(params: LoginFormType) {
    "use server";

    try {
      const validation = await LoginFormSchema.spa(params);

      if (!validation.success) {
        return {
          success: false,
          validationError: validation.error.format(),
        };
      }
      const { data } = await saleorAuthClient.signIn(
        {
          email: params.email,
          password: params.password,
        },
        { cache: "no-store" }
      );

      invariant(data.tokenCreate, "Something went wrong1");

      const { token, refreshToken } = data.tokenCreate;
      console.log(data.tokenCreate);

      invariant(token, "Something went wrong2");
      invariant(refreshToken, "Something went wrong3");

      return {
        success: true,
        message: undefined,
      };
    } catch (error: Error | any) {
      console.error(error);

      return {
        success: false,
        message: error?.message ?? "Something went wrong",
      };
    }
  }

  async function goBack() {
    "use server";

    redirect("/");
  }

  return (
    <section>
      <div className="flex flex-col gap-11">
        <LoginForm
          values={existingFormValues}
          completeAction={submitLoginForm}
          cancelAction={goBack}
        />
      </div>
    </section>
  );
}
