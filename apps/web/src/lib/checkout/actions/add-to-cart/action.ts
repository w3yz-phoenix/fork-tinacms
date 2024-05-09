"use server";

import {
  useCheckoutAddLineMutation,
  useCheckoutCreateMutation,
} from "@w3yz/ecom/api";
import { invariant } from "@w3yz/tools/lib";
import { unstable_noStore } from "next/cache";

import { setCookie } from "#web/lib/actions/actions.server";
import { createAction } from "#web/lib/actions/actions.utils";

import { getCurrentCheckout, revalidateCheckout } from "../../checkout.query";

import { AddItemToCartSchema } from "./schema";

const createCheckout = async () => {
  unstable_noStore();
  const response = await useCheckoutCreateMutation.fetcher({})();
  return response.checkoutCreate?.checkout?.id;
};

async function findOrCreateCheckout() {
  const checkout = await getCurrentCheckout();

  if (checkout?.id) {
    return checkout;
  }

  setCookie("checkoutId", await createCheckout());
  const createdCheckout = await getCurrentCheckout();

  invariant(createdCheckout?.id, "Checkout ID is not defined");

  return createdCheckout;
}

export const [addItemToCartAction, addItemToCartFormAction] = createAction(
  AddItemToCartSchema,
  async (parameters) => {
    const checkout = await findOrCreateCheckout();

    await useCheckoutAddLineMutation.fetcher({
      id: checkout.id,
      productVariantId: decodeURIComponent(parameters.variant),
      quantity: parameters.quantity,
    })();

    revalidateCheckout();

    return checkout.id;
  }
);
