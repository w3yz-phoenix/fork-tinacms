/* eslint-disable unicorn/consistent-function-scoping */
import {
  useAccountRegisterMutation,
  useCurrentUserQuery,
} from "@w3yz/ecom/api";
import { safeJsonParse } from "@w3yz/tools/lib";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";

import { setCookie } from "#storefront/lib/actions/actions.server";
import {
  getCurrentCheckout,
  revalidateCheckout,
} from "#storefront/lib/checkout/checkout.query";

import { RegisterForm } from "./form";
import { RegisterFormSchema, type RegisterFormType } from "./schemas";

export default async function RegisterPage() {
  const existingFormValues = {
    firstName: "",
    lastName: "",
    email: "",
    password: "",
  };

  const currentUser = await useCurrentUserQuery.fetcher()();

  if (currentUser.me) {
    return redirect("/");
  }

  async function submitRegisterForm(params: RegisterFormType) {
    "use server";

    try {
      const validation = await RegisterFormSchema.spa(params);

      if (!validation.success) {
        return {
          success: false,
          validationError: validation.error.format(),
        };
      }

      const response = await useAccountRegisterMutation.fetcher({
        email: params.email,
        password: params.password,
        firstname: params.firstName,
        lastname: params.lastName,
      })();

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
        <RegisterForm
          values={existingFormValues}
          completeAction={submitRegisterForm}
          cancelAction={goBack}
        />
      </div>
    </section>
  );
}
