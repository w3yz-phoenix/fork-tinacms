import { useCheckoutFindQuery } from "@w3yz/ecom/api";
import { cookies } from "next/headers";

export async function getCurrentCheckout() {
  const checkoutId = cookies().get("checkoutId")?.value;
  return findCheckout(checkoutId);
}

export async function findCheckout(checkoutId?: string) {
  if (!checkoutId) return;

  const response = await useCheckoutFindQuery.fetcher({ id: checkoutId })({
    cache: "no-cache",
  });

  return response.checkout;
}
