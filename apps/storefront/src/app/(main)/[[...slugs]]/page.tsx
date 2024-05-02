import { dehydrate, HydrationBoundary } from "@tanstack/react-query";
import { usePageQuery } from "@w3yz/cms-tina";
import { getQueryClient } from "@w3yz/core";

export default async function TinaPage({
  params,
}: {
  params: { slugs?: string[] };
}) {
  const queryClient = getQueryClient();

  const relativePath = `${params.slugs?.join("/")}.md`;

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
      <div>Page content goes here</div>
    </HydrationBoundary>
  );
}
