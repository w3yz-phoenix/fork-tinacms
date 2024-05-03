"use server";

import { usePageQuery } from "@w3yz/cms-tina";
import { dehydrate, HydrationBoundary } from "@tanstack/react-query";

import { getQueryClient, prefetchQuery } from "../../lib";

import { PageClient } from "./page.client";

export const Page = async ({ relativePath }: { relativePath: string }) => {
  const queryClient = getQueryClient();

  await prefetchQuery(queryClient, usePageQuery, { relativePath });

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <PageClient relativePath={relativePath} />
    </HydrationBoundary>
  );
};
