"use server";

import { useCheckoutSetQuantityMutation } from "@w3yz/ecom/api";

import { createAction } from "#web/lib/actions/actions.utils";

import { revalidateCheckout } from "../../checkout.query";

import { SetCheckoutLineQuantityActionSchema } from "./schema";

export const [setCheckoutQuantityAction, setCheckoutQuantityFormAction] =
  createAction(
    SetCheckoutLineQuantityActionSchema,
    async ({ lineId, checkoutId, quantity }) => {
      await useCheckoutSetQuantityMutation.fetcher({
        checkoutId,
        lineId,
        quantity,
      })();

      revalidateCheckout();
    }
  );
