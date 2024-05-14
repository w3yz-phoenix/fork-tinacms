/* eslint-disable unicorn/consistent-function-scoping */
import { invariant } from "@w3yz/tools/lib";
import { redirect } from "next/navigation";

import {
  getCurrentCheckout,
  revalidateCheckout,
} from "#web/lib/checkout/checkout.query";
import { setCookie } from "#web/lib/actions/actions.server";

import { CheckoutPaymentButtonForm } from "./form";
import {
  CheckoutPaymentButtonFormSchema,
  type CheckoutPaymentButtonFormType,
} from "./schemas";
import { completeCheckout } from "./actions";

export async function CheckoutPaymentButton() {
  async function submitForm(params: CheckoutPaymentButtonFormType) {
    "use server";

    try {
      const validation = await CheckoutPaymentButtonFormSchema.spa(params);

      if (!validation.success) {
        return {
          success: false,
          validationError: validation.error.format(),
        };
      }

      const checkout = await getCurrentCheckout();

      invariant(checkout?.id, "Checkout must be defined");
      invariant(validation.data.contractChecked, "Contract must be checked");
      invariant(validation.data.termsChecked, "Terms must be checked");

      const response = await completeCheckout();

      setCookie(
        "redirectInformation",
        JSON.stringify({ type: "payment", url: response.data.paymentPageUrl })
      );

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
    <div className="flex flex-col gap-11">
      <CheckoutPaymentButtonForm
        values={{}}
        completeAction={submitForm}
        cancelAction={goBack}
      />
    </div>
  );
}
