"use server";

import { dehydrate, HydrationBoundary } from "@tanstack/react-query";
import { useGlobalConfigQuery } from "@w3yz/cms/api";
import { defaultGlobalConfig } from "@w3yz/cms/config";
import { useCheckoutGetQuantitiesQuery } from "@w3yz/ecom/api";
import { getStringIfNotEmpty } from "@w3yz/tools/lib";
import { cookies } from "next/headers";

import { getQueryClient, prefetchQuery } from "#ui/core/lib/tanstack-query";
import { CheckoutIdProvider } from "#ui/core/providers/checkout-id-provider";

import { Footer } from "./footer";
import { Header } from "./header";

async function getCheckoutItemCount() {
  const checkoutId = getStringIfNotEmpty(cookies().get("checkoutId")?.value);

  if (!checkoutId) {
    return 0;
  }

  const response = await useCheckoutGetQuantitiesQuery.fetcher({
    id: checkoutId,
  })();

  return (
    response?.checkout?.lines?.reduce((accumulator, line) => {
      return accumulator + line.quantity;
    }, 0) ?? 0
  );
}

export async function Layout({
  globalConfigPath = defaultGlobalConfig,
  children,
}: {
  globalConfigPath?: string;
  children: React.ReactNode;
}) {
  const checkoutId = getStringIfNotEmpty(cookies().get("checkoutId")?.value);
  const queryClient = getQueryClient();

  await prefetchQuery(queryClient, useGlobalConfigQuery, {
    relativePath: globalConfigPath,
  });

  const cartItemCount = await getCheckoutItemCount();

  return (
    <CheckoutIdProvider checkoutId={checkoutId ?? "none"}>
      <HydrationBoundary state={dehydrate(queryClient)}>
        <Header
          cartItemCount={cartItemCount}
          globalConfigPath={globalConfigPath}
        />
        <div>{children}</div>
        <Footer />
      </HydrationBoundary>
    </CheckoutIdProvider>
  );
}
