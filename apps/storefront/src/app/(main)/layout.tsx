import { dehydrate, HydrationBoundary } from "@tanstack/react-query";

import { Layout } from "src/components/tina/demo/layout";
import { useLayoutQuery } from "src/generated/gql/tinacms.gen";
import { getQueryClient } from "src/lib/providers/tanstack-query";

export default async function MainLayout(props: { children: React.ReactNode }) {
  const queryClient = getQueryClient();

  await queryClient.prefetchQuery({
    queryKey: useLayoutQuery.getKey({
      relativePath: "main.json",
    }),
    queryFn: useLayoutQuery.fetcher({
      relativePath: "main.json",
    }),
  });

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <Layout>
        <div>{props.children}</div>
      </Layout>
    </HydrationBoundary>
  );
}
