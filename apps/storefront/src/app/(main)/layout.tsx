import { dehydrate, HydrationBoundary } from "@tanstack/react-query";
import { getQueryClient } from "@w3yz/core";

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
