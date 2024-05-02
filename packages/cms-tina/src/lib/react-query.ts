import type { QueryClient } from "@tanstack/react-query";

export const prefetchTinaQuery = async <
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
  await queryClient.prefetchQuery({
    queryKey: useHook.getKey(variables),
    queryFn: useHook.fetcher(variables),
  });
};
