"use server";

import { createAction } from "#web/lib/actions/actions.utils";
import { revalidateCheckout } from "#web/lib/checkout/checkout.query";

import { CheckoutContactPageSubmitFormActionSchema } from "./schemas";

export const [, checkoutContactPageSubmitFormAction] = createAction(
  CheckoutContactPageSubmitFormActionSchema,
  async (parameters) => {
    console.log("parameters", parameters);
    revalidateCheckout();

    return "unimplemented success";
  },
  false
);
