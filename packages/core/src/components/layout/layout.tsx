import { dehydrate, HydrationBoundary } from "@tanstack/react-query";
import { useGlobalConfigQuery } from "@w3yz/cms-tina";

import { getQueryClient } from "@w3yz/core";

import { Header } from "./header";
import { Footer } from "./footer";

export async function Layout(props: {
  globalConfigPath: string;
  children: React.ReactNode;
}) {
  const queryClient = getQueryClient();

  await queryClient.prefetchQuery({
    queryKey: useGlobalConfigQuery.getKey({
      relativePath: props.globalConfigPath,
    }),
    queryFn: useGlobalConfigQuery.fetcher({
      relativePath: props.globalConfigPath,
    }),
  });

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <Header />
      <div>{props.children}</div>
      <Footer />
    </HydrationBoundary>
  );
}
