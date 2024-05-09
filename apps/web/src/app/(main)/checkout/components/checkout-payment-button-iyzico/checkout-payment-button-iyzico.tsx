"use client";

import Image from "next/image";

import { SubmitButton } from "#web/components/submit-button";

import iyzicoImageUrl from "./iyzico-white-banner.png";

export type CheckoutPaymentButtonIyzicoProperties = {
  disabled?: boolean;
};

export function CheckoutPaymentButtonIyzico(
  props: CheckoutPaymentButtonIyzicoProperties
) {
  // FIXME: Redirect to payment page
  // if (formSubmitState?.success && formSubmitState.data?.data?.paymentPageUrl) {
  //   return redirect(
  //     `/external-redirect/?url=${encodeURIComponent(
  //       formSubmitState.data?.data?.paymentPageUrl
  //     )}`
  //   );
  // }

  return (
    <div>
      <SubmitButton
        disabled={props.disabled}
        className="mb-3 flex w-full items-center justify-center rounded-lg  bg-[#00C48C] py-3 font-medium hover:bg-[#008362] disabled:bg-[#A0FAD5]"
      >
        <Image
          src={iyzicoImageUrl}
          alt="iyzico ödeme"
          height={20}
          width={135}
        />
      </SubmitButton>

      {/* <p className="mt-2 block text-[14px] text-[#222]">
        {formSubmitState?.message}
      </p> */}
    </div>
  );
}
