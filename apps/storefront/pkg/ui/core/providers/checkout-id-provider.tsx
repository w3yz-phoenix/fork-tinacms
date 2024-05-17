"use client";

import { useCheckoutFindQuery } from "@w3yz/ecom/api";
import { createContext, useContext } from "react";

export type CheckoutIdContextType = "none" | string | undefined;

export const CheckoutIdContext =
  createContext<CheckoutIdContextType>(undefined);

export const useCheckoutId = () => {
  const checkoutId = useContext(CheckoutIdContext);

  if (!checkoutId) {
    throw new Error("useCheckoutId must be used within a CheckoutIdProvider");
  }

  return checkoutId;
};

export const useCurrentCheckoutQuery = () => {
  const checkoutId = useCheckoutId();
  const query = useCheckoutFindQuery({ id: checkoutId });

  return [query.data?.checkout, query] as const;
};

export const CheckoutIdProvider = (props: {
  checkoutId: CheckoutIdContextType;
  children: React.ReactNode;
}) => {
  return (
    <CheckoutIdContext.Provider value={props.checkoutId}>
      {props.children}
    </CheckoutIdContext.Provider>
  );
};
