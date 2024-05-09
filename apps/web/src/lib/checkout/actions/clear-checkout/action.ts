"use server";

import { useCheckoutDeleteLinesMutation } from "@w3yz/ecom/api";

import { setCookie } from "#web/lib/actions/actions.server";
import { createAction } from "#web/lib/actions/actions.utils";

import { revalidateCheckout } from "../../checkout.query";

import { ClearCheckoutActionSchema } from "./schema";

export const [clearCheckoutAction, clearCheckoutFormAction] = createAction(
  ClearCheckoutActionSchema,
  async (parameters) => {
    await useCheckoutDeleteLinesMutation.fetcher(parameters)();

    setCookie("checkoutId", undefined);

    revalidateCheckout();

    return "yes";
  }
);
