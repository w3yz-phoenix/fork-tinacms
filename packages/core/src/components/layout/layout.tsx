"use server";

import { dehydrate, HydrationBoundary } from "@tanstack/react-query";
import {
  defaultGlobalConfig,
  prefetchTinaQuery,
  useGlobalConfigQuery,
} from "@w3yz/cms-tina";

import { getQueryClient } from "@w3yz/core";

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

  await prefetchTinaQuery(queryClient, useGlobalConfigQuery, {
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
