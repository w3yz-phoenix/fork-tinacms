import { useCheckoutFindQuery } from "@w3yz/ecom/api";
import { getStringIfNotEmpty } from "@w3yz/tools/lib";
import { revalidatePath, revalidateTag, unstable_cache } from "next/cache";
import { cookies } from "next/headers";

const fetchCheckout = unstable_cache(
  async (id: string) => {
    const response = await useCheckoutFindQuery.fetcher({ id })();
    return response.checkout;
  },
  ["checkout"],
  {
    tags: ["checkout"],
    revalidate: 60,
  }
);

export async function getCurrentCheckout() {
  const checkoutId = getStringIfNotEmpty(cookies().get("checkoutId")?.value);

  if (!checkoutId) return;

  return fetchCheckout(checkoutId);
}

export function revalidateCheckout() {
  revalidatePath("/checkout", "layout");
  revalidateTag("checkout");
}
