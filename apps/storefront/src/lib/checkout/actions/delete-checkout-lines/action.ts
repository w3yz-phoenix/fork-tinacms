"use server";

import { useCheckoutDeleteLinesMutation } from "@w3yz/ecom/api";

import { createAction } from "#storefront/lib/actions/actions.utils";

import { revalidateCheckout } from "../../checkout.query";

import { DeleteCheckoutLinesActionSchema } from "./schema";

export const [deleteCheckoutLinesAction, deleteCheckoutLinesFormAction] =
  createAction(DeleteCheckoutLinesActionSchema, async (parameters) => {
    await useCheckoutDeleteLinesMutation.fetcher(parameters)();

    revalidateCheckout();
  });
