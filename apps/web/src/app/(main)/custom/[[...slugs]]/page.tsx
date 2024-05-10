"use server";

import { getQueryClient, prefetchQuery } from "#ui/core/lib/tanstack-query";
import { dehydrate, HydrationBoundary } from "@tanstack/react-query";
import { useCustomPageQuery } from "@w3yz/cms/api";

import { CustomPageClient } from "./page.client";

export default async function CustomPage({
  params,
}: {
  params: { slugs?: string[] };
}) {
  const relativePath = `${params.slugs?.join("/")}.mdx`;
  const queryClient = getQueryClient();

  await prefetchQuery(queryClient, useCustomPageQuery, { relativePath });

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <CustomPageClient relativePath={relativePath} />
    </HydrationBoundary>
  );
}
