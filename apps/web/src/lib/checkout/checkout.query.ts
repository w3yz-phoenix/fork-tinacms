import { useCheckoutFindQuery } from "@w3yz/ecom/api";

export async function findCheckout(checkoutId?: string) {
  if (!checkoutId) return;

  const response = await useCheckoutFindQuery.fetcher({ id: checkoutId })();

  return response.checkout;
}
