import { useTina, useEditState, tinaField } from "tinacms/dist/react";

export { tinaField } from "tinacms/dist/react";

import type { SetReturnType } from "type-fest";

// eslint-disable-next-line unicorn/prevent-abbreviations
export const tinaFieldProps: SetReturnType<
  typeof tinaField,
  { "data-tina-field": string }
> = (data, field) => {
  return { "data-tina-field": tinaField(data, field) };
};

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
