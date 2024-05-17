/* eslint-disable unicorn/consistent-function-scoping */
import { useCheckoutEmailUpdateMutation } from "@w3yz/ecom/api";
import { getStringIfNotEmpty, invariant, safeJsonParse } from "@w3yz/tools/lib";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";

import { setCookie } from "#storefront/lib/actions/actions.server";
import {
  getCurrentCheckout,
  revalidateCheckout,
} from "#storefront/lib/checkout/checkout.query";

import { CheckoutFormAccordion } from "../../components/checkout-form-accordion";

import { CheckoutContactForm } from "./form";
import {
  CheckoutContactFormSchema,
  type CheckoutContactFormType,
} from "./schemas";

export default async function CheckoutContactPage() {
  const checkout = await getCurrentCheckout();
  const cookieValidation = await CheckoutContactFormSchema.safeParseAsync(
    safeJsonParse(cookies().get("checkoutContactForm")?.value)
  );

  const existingFormValues = cookieValidation.success
    ? cookieValidation.data
    : {
        email: getStringIfNotEmpty(checkout.email),
        phone: getStringIfNotEmpty(checkout.shippingAddress?.phone),
      };

  async function submitCheckoutContactForm(params: CheckoutContactFormType) {
    "use server";

    try {
      const validation = await CheckoutContactFormSchema.spa(params);

      if (!validation.success) {
        return {
          success: false,
          validationError: validation.error.format(),
        };
      }

      const checkout = await getCurrentCheckout();

      invariant(checkout?.id, "Checkout must be defined");

      const { email, phone } = validation.data;

      setCookie(
        "checkoutContactForm",
        JSON.stringify({
          email,
          phone,
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

    redirect("/checkout");
  }

  return (
    <CheckoutFormAccordion currentStep="contact">
      <div className="flex flex-col gap-11">
        <CheckoutContactForm
          values={existingFormValues}
          completeAction={submitCheckoutContactForm}
          cancelAction={goBack}
        />
      </div>
    </CheckoutFormAccordion>
  );
}
