import { ServerActionForm } from "#ui/core/components/server-action-form/server-action-form";
import { IconX } from "@w3yz/shadcn/tabler-icons";
import { formatMoney, invariant } from "@w3yz/tools/lib";
import Link from "next/link";

import { SubmitButton } from "#web/components/submit-button";
import { clearCheckoutFormAction } from "#web/lib/checkout/actions/clear-checkout/action";
import { getCurrentCheckout } from "#web/lib/checkout/checkout.query";

import { CheckoutLine } from "./checkout-line";
import { CheckoutPaymentButtonIyzico } from "./checkout-payment-button-iyzico/checkout-payment-button-iyzico";

const PaymentWarning = (props: { message: string }) => {
  return (
    <div
      className={
        "mb-2 w-full justify-center rounded-lg bg-[#292929] p-2 text-[12px] text-[#F6F6F6] sm:px-4 md:text-sm"
      }
    >
      {props.message}
    </div>
  );
};

export const CheckoutSummary = async () => {
  const checkout = await getCurrentCheckout();

  invariant(checkout?.id, "Checkout is not defined");

  const lines = checkout?.lines.map((l) => l.id) ?? [];
  const checkoutId = checkout?.id;

  // FIXME: Implement payment availability and agreement check
  const placeholderState = {
    paymentAvailable: false,
    agreementChecked: false,
  };

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

        {checkout?.lines?.map((line) => (
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

        <label className="flex gap-2.5 rounded pt-6 text-[14px] font-normal text-[#344054]">
          <input
            type="checkbox"
            name="service"
            className="h-5 w-[20px] border-2 border-[#D0D5DD] accent-[#4C4F52]"
          />

          <div className="3xl:mb-8 mb-4 max-w-[408px] text-sm text-[#292929]">
            <Link href="/" className="font-semibold">
              Ön Bilgilendirme Koşulları
            </Link>
            <span>’ını ve</span>{" "}
            <Link href="/" className="font-semibold">
              Mesafeli Satış Sözleşmesi
            </Link>
            <span>’ni okudum, onaylıyorum.</span>
          </div>
        </label>

        <CheckoutPaymentButtonIyzico
          disabled={!placeholderState.paymentAvailable}
        />

        {!placeholderState.paymentAvailable && (
          <PaymentWarning message="İletişim Bilgileri ve Adres Bilgileri doldurulmalıdır." />
        )}
        {!placeholderState.agreementChecked && (
          <PaymentWarning message="Sözleşmeleri onaylamalısınız." />
        )}
      </div>
    </div>
  );
};
