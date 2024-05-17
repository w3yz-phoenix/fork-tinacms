import { formatMoney, invariant } from "@w3yz/tools/lib";
import Image from "next/image";
import { IconX } from "@tabler/icons-react";

import { ServerActionForm } from "#ui/core/components/server-action-form/server-action-form";
import { DangerousSaleorRichText } from "#storefront/components/dangerous-saleor-rich-text";
import { setCheckoutQuantityAction } from "#storefront/lib/checkout/actions/set-checkout-quantity/action";
import { getCurrentCheckout } from "#storefront/lib/checkout/checkout.query";
import { deleteCheckoutLinesFormAction } from "#storefront/lib/checkout/actions/delete-checkout-lines/action";
import { SubmitButton } from "#storefront/components/submit-button";

import { CheckoutLineQuantity } from "./checkout-line-quantity";

export const CheckoutLine = async (props: { id: string }) => {
  const checkout = await getCurrentCheckout();

  const checkoutLine = checkout?.lines.find((line) => line.id === props.id);

  invariant(checkoutLine, "Checkout line is not defined");

  return (
    <div className="border-b border-[#222] bg-white p-5">
      <div className="flex">
        <div className="max-h-[225px] max-w-[160px] md:max-h-[140px]">
          <Image
            src={checkoutLine.variant.product.thumbnail?.url ?? ""}
            alt={checkoutLine.variant.product.thumbnail?.alt ?? ""}
            height={140}
            width={160}
            className="hidden size-full object-cover lg:block"
          />
          <Image
            src={checkoutLine.variant.product.thumbnail?.url ?? ""}
            alt="sepetim-image"
            height={225}
            width={160}
            className="size-full object-cover lg:hidden"
          />
        </div>
        <div className="ml-5 flex flex-1 flex-col">
          <div className="flex items-start justify-between ">
            <h5>{checkoutLine.variant.product.name}</h5>
            <p className="hidden text-xl font-medium leading-normal text-[#292929] md:block xl:hidden 2xl:block">
              {formatMoney(
                Number(checkoutLine.variant.pricing?.price?.gross.amount) *
                  checkoutLine.quantity,
                checkoutLine.variant.pricing?.price?.gross.currency ?? "TRY"
              )}
            </p>
          </div>

          <div className="mt-2 line-clamp-3 min-h-[58px] max-w-[193px] overflow-hidden text-ellipsis text-[12px] italic text-[#656565] sm:text-sm md:line-clamp-4 md:min-h-20 md:max-w-[300px]">
            <DangerousSaleorRichText
              json={checkoutLine.variant.product.description}
            />
          </div>
          <p className="mt-2 text-xl font-medium leading-normal text-[#292929] md:hidden xl:block  2xl:hidden">
            {formatMoney(
              Number(checkoutLine.variant.pricing?.price?.gross.amount) *
                checkoutLine.quantity,
              checkoutLine.variant.pricing?.price?.gross.currency ?? "TRY"
            )}
          </p>
          <div className="mt-5 flex items-center justify-between max-md:mt-4 max-md:gap-3">
            <CheckoutLineQuantity
              quantity={checkoutLine.quantity}
              incrementAction={setCheckoutQuantityAction.bind(null, {
                lineId: checkoutLine.id,
                checkoutId: checkout?.id ?? "",
                quantity: checkoutLine.quantity + 1,
              })}
              decrementAction={setCheckoutQuantityAction.bind(null, {
                lineId: checkoutLine.id,
                checkoutId: checkout?.id ?? "",
                quantity: checkoutLine.quantity - 1,
              })}
            />
            <ServerActionForm
              action={deleteCheckoutLinesFormAction}
              fields={{
                lines: [checkoutLine.id],
                checkoutId: checkout?.id,
              }}
            >
              <SubmitButton variant="link">
                <IconX size={20} />
              </SubmitButton>
            </ServerActionForm>
          </div>
        </div>
      </div>
    </div>
  );
};
