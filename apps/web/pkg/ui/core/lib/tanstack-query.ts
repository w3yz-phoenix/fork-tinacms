import { QueryClient } from "@tanstack/react-query";

import { isClient } from "./utils";

function makeQueryClient() {
  return new QueryClient({
    defaultOptions: {
      queries: {
        // With SSR, we usually want to set some default staleTime
        // above 0 to avoid refetching immediately on the client
        staleTime: 60 * 1000,
      },
    },
  });
}

let browserQueryClient: QueryClient | undefined;

export function getQueryClient() {
  if (isClient()) {
    // Browser: make a new query client if we don't already have one
    // This is very important so we don't re-make a new client if React
    // supsends during the initial render. This may not be needed if we
    // have a suspense boundary BELOW the creation of the query client
    if (!browserQueryClient) browserQueryClient = makeQueryClient();
    return browserQueryClient;
  } else {
    // Server: always make a new query client
    return makeQueryClient();
  }
}

export const prefetchQuery = async <
  THook extends {
    (variables: any): { data: unknown };
    getKey: (variables: any) => any;
    fetcher: (variables: any) => any;
  } = {
    (variables: any): { data: unknown };
    getKey: (variables: any) => any;
    fetcher: (variables: any) => any;
  },
  TVariables = THook extends (variables: infer V, ...rest: any[]) => any
    ? V
    : never,
>(
  queryClient: QueryClient,
  useHook: THook,
  variables: TVariables
) => {
  const options = {
    queryKey: useHook.getKey(variables),
    queryFn: useHook.fetcher(variables),
  };

  return await queryClient.prefetchQuery(options);
};
