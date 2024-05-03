"use server";

import { dehydrate, HydrationBoundary } from "@tanstack/react-query";
import { defaultGlobalConfig, useGlobalConfigQuery } from "@w3yz/gql-tina";

import { getQueryClient, prefetchQuery } from "@w3yz/ui-core";

import { Header } from "./header";
import { Footer } from "./footer";

export async function Layout({
  globalConfigPath = defaultGlobalConfig,
  children,
}: {
  globalConfigPath?: string;
  children: React.ReactNode;
}) {
  const queryClient = getQueryClient();

  await prefetchQuery(queryClient, useGlobalConfigQuery, {
    relativePath: globalConfigPath,
  });

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <Header globalConfigPath={globalConfigPath} />
      <div>{children}</div>
      <Footer />
    </HydrationBoundary>
  );
}
