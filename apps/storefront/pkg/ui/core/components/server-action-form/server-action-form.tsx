"use client";

import { useFormState } from "react-dom";
import {
  initialActionState,
  type ActionErrors,
  type FormAction,
} from "#storefront/lib/actions/actions.utils";

export const ServerActionForm = <
  const TAction extends FormAction<TParams, TError>,
  const TParams extends Record<string, any> = TAction extends FormAction<
    infer P,
    never
  >
    ? P
    : never,
  const TError extends ActionErrors<
    Zod.Schema<TParams>
  > = TAction extends FormAction<never, infer P> ? P : never,
>(props: {
  action: FormAction<TParams, TError>;
  fields: TParams;
  children: React.ReactNode;
}) => {
  const [formSubmitState, action] = useFormState(
    props.action,
    initialActionState
  );

  if (
    formSubmitState.type === "error" &&
    formSubmitState.error.name === "ValidationError"
  ) {
    console.error("ServerActionForm Error:", formSubmitState.error.fieldErrors);
  }

  return (
    <form action={action} className="flex min-w-40">
      <>
        {Object.entries(props.fields).map(([key, value]) => (
          <input
            key={key}
            type="hidden"
            name={key}
            value={JSON.stringify(value)}
          />
        ))}
      </>
      {props.children}
    </form>
  );
};
