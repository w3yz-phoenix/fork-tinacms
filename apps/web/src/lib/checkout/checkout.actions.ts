"use server";

import {
  useCheckoutAddLineMutation,
  useCheckoutCreateMutation,
} from "@w3yz/ecom/api";
import { invariant } from "@w3yz/tools/lib";
import { cookies } from "next/headers";

import { createAction, setCookie } from "../actions/actions.utils";

import { findCheckout } from "./checkout.query";
import { AddItemToCartSchema } from "./checkout.schema";

export const createCheckout = async () => {
  const response = await useCheckoutCreateMutation.fetcher({})({
    cache: "no-cache",
  });
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
    const checkout = await findOrCreateCheckout(
      cookies().get("checkoutId")?.value
    );

    invariant(checkout?.id, "Checkout ID is not defined");

    setCookie("checkoutId", checkout.id);

    invariant(parameters?.quantity > 0, "Quantity must be greater than 0");
    invariant(parameters?.product, "Product must be defined");
    invariant(parameters?.variant, "Variant must be defined");

    await useCheckoutAddLineMutation.fetcher({
      id: checkout.id,
      productVariantId: decodeURIComponent(parameters.variant),
      quantity: parameters.quantity,
      cartela: parameters.cartela ?? "yok",
    })({ cache: "no-cache" });

    return checkout.id;
  }
);
