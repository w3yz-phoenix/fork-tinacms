"use client";

import { redirect } from "next/navigation";
import { useFormState } from "react-dom";

import { SubmitButton } from "@@web/components/submit-button";
import { addItemToCart } from "@@web/lib/checkout/checkout.actions";
import { initialActionState } from "@@web/lib/actions/actions.utils";

type AddToCartButtonProperties = {
  productId: string;
  variantId: string;
  quantity: number;
  disabled?: boolean;
  cartela?: string | null;
};

export const AddToCartButton = ({
  productId,
  variantId,
  quantity,
  disabled,
  cartela,
}: AddToCartButtonProperties) => {
  const [formState, formAction] = useFormState(
    addItemToCart,
    initialActionState
  );

  if (formState?.state === "success") {
    return redirect("/checkout/cart");
  }

  return (
    <form action={formAction}>
      <input type="hidden" name="product" value={productId} />
      <input type="hidden" name="variant" value={variantId} />
      <input type="hidden" name="quantity" value={quantity} />
      {cartela && <input type="hidden" name="cartela" value={cartela} />}

      <SubmitButton
        disabled={disabled}
        className="mt-4 h-[44px] w-full items-center rounded bg-[#EC8065] py-2.5 font-medium text-white hover:bg-[#CF7059] active:rounded-lg active:border-white active:bg-[#252627] sm:w-[312px]"
      >
        Sepete Ekle
      </SubmitButton>
    </form>
  );
};
