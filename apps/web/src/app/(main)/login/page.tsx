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

export default async function RegisterPage() {
  const checkout = await getCurrentCheckout();
  const cookieValidation = await LoginFormSchema.safeParseAsync(
    safeJsonParse(cookies().get("LoginForm")?.value)
  );

  const existingFormValues = cookieValidation.success
    ? cookieValidation.data
    : {
        email: getStringIfNotEmpty(checkout.email),
        phone: getStringIfNotEmpty(checkout.shippingAddress?.phone),
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

      const checkout = await getCurrentCheckout();

      invariant(checkout?.id, "Checkout must be defined");

      const { email, password } = validation.data;

      setCookie(
        "LoginForm",
        JSON.stringify({
          email,
          password,
        })
      );

      await useCheckoutEmailUpdateMutation.fetcher({
        id: checkout.id,
        email,
      })();

      revalidateCheckout();

      return {
        success: true,
      };
    } catch (error) {
      console.error(error);

      return {
        success: false,
        error: (error as any).message,
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
