"use server";

import { dehydrate, HydrationBoundary } from "@tanstack/react-query";
import { defaultGlobalConfig } from "@w3yz/cms/config";
import { useGlobalConfigQuery } from "@w3yz/cms/api";

import { getQueryClient, prefetchQuery } from "@@ui/core/lib/tanstack-query";

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

  const state = dehydrate(queryClient);

  console.log("layout-state:", state);

  return (
    <HydrationBoundary state={state}>
      <Header globalConfigPath={globalConfigPath} />
      <div>{children}</div>
      <Footer />
    </HydrationBoundary>
  );
}
