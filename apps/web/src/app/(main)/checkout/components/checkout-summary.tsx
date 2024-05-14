import { ServerActionForm } from "#ui/core/components/server-action-form/server-action-form";
import { IconX } from "@tabler/icons-react";
import { formatMoney } from "@w3yz/tools/lib";

import { SubmitButton } from "#web/components/submit-button";
import { clearCheckoutFormAction } from "#web/lib/checkout/actions/clear-checkout/action";
import { getCurrentCheckout } from "#web/lib/checkout/checkout.query";

import { CheckoutLine } from "./checkout-line";
import { CheckoutPaymentButton } from "./checkout-payment-button/component";

export const CheckoutSummary = async () => {
  const checkout = await getCurrentCheckout();

  const lines = checkout.lines.map((l) => l.id) ?? [];
  const checkoutId = checkout.id;

  return (
    <div className="flex grow flex-col justify-between bg-[#F6F6F6] px-6 py-[6%] sm:px-[6%] xl:px-[12.5%]">
      <div>
        <div className="3xl:mb-8 flex items-center justify-between">
          <h3 className="3xl:mb-3 3xl:text-3xl mb-1 text-2xl font-semibold text-[#292929]">
            Hesap Özeti
          </h3>

          <div className="flex min-w-40"></div>

          <ServerActionForm
            action={clearCheckoutFormAction}
            fields={{ lines, checkoutId }}
          >
            <SubmitButton variant="default">
              <div className="">Sepeti Boşalt</div>
              <div className="size-5">
                <IconX size={20} />
              </div>
            </SubmitButton>
          </ServerActionForm>
        </div>

        <div className="3xl:mb-8  mb-4">
          <p className="3xl:text-[16px] text-sm text-[#656565]">
            Sepetinizdeki ürünleri görüntüleyin
          </p>
        </div>

        {checkout.lines?.map((line) => (
          <CheckoutLine key={line.id} id={line.id} />
        ))}
      </div>

      <div className="3xl:text-[16px] mt-10 text-sm">
        <div className="mb-2 flex justify-between text-[#292929]">
          <div>Ara toplam</div>
          <div className="3xl:text-[20px]">
            {formatMoney(checkout.subtotalPrice.gross)}
          </div>
        </div>

        <div className="flex justify-between text-[#292929]">
          <div>Kargo ücreti</div>
          <div className="3xl:text-[20px]">
            {formatMoney(checkout.shippingPrice.gross)}
          </div>
        </div>

        <div className="my-3 h-px w-full bg-[#BDBDBD]"></div>

        <div className="mb-2 flex justify-between text-[#292929]">
          <div className="font-medium text-[#292929]">Toplam</div>
          <div className="3xl:text-[20px] font-medium">
            {formatMoney(checkout.totalPrice.gross)}
          </div>
        </div>

        <div className="text-xs">Vergiler dahildir</div>

        <CheckoutPaymentButton />
      </div>
    </div>
  );
};
