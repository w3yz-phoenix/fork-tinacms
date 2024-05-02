import { dehydrate, HydrationBoundary } from "@tanstack/react-query";
import { useGlobal_ConfigQuery } from "@w3yz/cms-tina";
import { getQueryClient } from "@w3yz/core";

export default async function MainLayout(props: { children: React.ReactNode }) {
  const queryClient = getQueryClient();

  await queryClient.prefetchQuery({
    queryKey: useGlobal_ConfigQuery.getKey({
      relativePath: "main.json",
    }),
    queryFn: useGlobal_ConfigQuery.fetcher({
      relativePath: "main.json",
    }),
  });

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <div>{props.children}</div>
    </HydrationBoundary>
  );
}
