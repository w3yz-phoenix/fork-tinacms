"use server";

import {
  useCheckoutAddLineMutation,
  useCheckoutCreateMutation,
} from "@w3yz/ecom/api";
import { invariant, publicEnvironment } from "@w3yz/tools/lib";
import { cookies } from "next/headers";
import { unstable_noStore } from "next/cache";

import { createAction } from "../actions/actions.utils";

import { findCheckout } from "./checkout.query";
import { AddItemToCartSchema } from "./checkout.schema";

const createCheckout = async () => {
  unstable_noStore();
  const response = await useCheckoutCreateMutation.fetcher({})();
  return response.checkoutCreate?.checkout?.id;
};

async function findOrCreateCheckout(inputCheckoutId?: string) {
  let checkout = await findCheckout(inputCheckoutId);

  if (!checkout?.id) {
    const checkoutId = await createCheckout();
    checkout = await findCheckout(checkoutId ?? "");
  }

  return checkout;
}

export const addItemToCart = createAction(
  AddItemToCartSchema,
  async (parameters) => {
    unstable_noStore();

    const checkout = await findOrCreateCheckout(
      cookies().get("checkoutId")?.value
    );

    invariant(checkout?.id, "Checkout ID is not defined");

    cookies().set("checkoutId", checkout.id, {
      secure: publicEnvironment.ecom.https,
      sameSite: "lax",
      httpOnly: true,
      maxAge: 60 * 60 * 24 * 365 * 10,
    });

    invariant(parameters?.quantity > 0, "Quantity must be greater than 0");
    invariant(parameters?.product, "Product must be defined");
    invariant(parameters?.variant, "Variant must be defined");

    await useCheckoutAddLineMutation.fetcher({
      id: checkout.id,
      productVariantId: decodeURIComponent(parameters.variant),
      quantity: parameters.quantity,
      cartela: parameters.cartela ?? "yok",
    })();

    return checkout.id;
  }
);
