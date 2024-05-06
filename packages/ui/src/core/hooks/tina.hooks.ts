import { useEditState, useTina } from "tinacms/dist/react";

export { tinaField } from "tinacms/dist/react";

export const useTinaQuery = <
  TData,
  THook extends {
    (variables: any): { data: unknown };
    document: string;
  } = {
    (variables: any): { data: unknown };
    document: string;
  },
  TVariables = THook extends (variables: infer V, ...rest: any[]) => any
    ? V
    : never,
>(
  useHook: THook,
  variables: TVariables
) => {
  const myQuery = useHook(variables);

  const layoutProperties = {
    query: useHook.document,
    variables: variables,
    data: myQuery.data ?? {},
  };

  const editState = useEditState();
  const tinaResponse = useTina(layoutProperties as any);

  const data = editState.edit ? tinaResponse.data : myQuery.data;

  return (data ?? {}) as TData;
};
