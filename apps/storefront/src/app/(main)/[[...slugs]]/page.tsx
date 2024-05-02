import { redirect } from "next/navigation";
import { dehydrate, HydrationBoundary } from "@tanstack/react-query";

import { PageContainer } from "src/components/tina/page-container";
import { getQueryClient } from "src/lib/providers/tanstack-query";
import { usePageQuery } from "src/generated/gql/tinacms.gen";

export default async function TinaPage({
  params,
}: {
  params: { slugs?: string[] };
}) {
  const queryClient = getQueryClient();

  const filenameParameter = params.slugs?.join("/") ?? "home";

  if (filenameParameter === "admin") {
    return redirect("/admin/index.html");
  }

  const relativePath = `${filenameParameter ?? "home"}.md`;

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
      <PageContainer relativePath={relativePath} />
    </HydrationBoundary>
  );
}
