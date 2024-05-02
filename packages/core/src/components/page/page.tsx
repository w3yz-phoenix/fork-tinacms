"use server";

import { usePageQuery } from "@w3yz/cms-tina";
import { dehydrate, HydrationBoundary } from "@tanstack/react-query";

import { getQueryClient } from "../../lib";

import { PageClient } from "./page.client";

export const Page = async ({ relativePath }: { relativePath: string }) => {
  const queryClient = getQueryClient();

  await queryClient.prefetchQuery({
    queryKey: usePageQuery.getKey({
      relativePath,
    }),
    queryFn: usePageQuery.fetcher({
      relativePath,
    }),
  });

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <PageClient relativePath={relativePath} />
    </HydrationBoundary>
  );
};
