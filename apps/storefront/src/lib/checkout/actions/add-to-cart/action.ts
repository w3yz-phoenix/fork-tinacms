"use server";

import {
  useCheckoutAddLineMutation,
  useCheckoutCreateMutation,
  useCheckoutFindQuery,
} from "@w3yz/ecom/api";
import { getStringIfNotEmpty, invariant } from "@w3yz/tools/lib";
import { unstable_noStore } from "next/cache";
import { cookies } from "next/headers";

import { setCookie } from "#storefront/lib/actions/actions.server";
import { createAction } from "#storefront/lib/actions/actions.utils";

import { getCurrentCheckout, revalidateCheckout } from "../../checkout.query";

import { AddItemToCartSchema } from "./schema";

const createCheckout = async () => {
  unstable_noStore();
  const response = await useCheckoutCreateMutation.fetcher({})();
  return response.checkoutCreate?.checkout?.id;
};

async function safeGetCurrentCheckout() {
  const checkoutId = getStringIfNotEmpty(cookies().get("checkoutId")?.value);

  if (!checkoutId) {
    return;
  }

  const response = await useCheckoutFindQuery.fetcher({
    id: checkoutId,
  })();

  return response.checkout;
}

async function findOrCreateCheckout() {
  const checkout = await safeGetCurrentCheckout();

  if (checkout?.id) {
    return checkout;
  }

  setCookie("checkoutId", await createCheckout());
  const createdCheckout = await getCurrentCheckout();

  invariant(createdCheckout?.id, "Newly created checkout could not be found");

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
