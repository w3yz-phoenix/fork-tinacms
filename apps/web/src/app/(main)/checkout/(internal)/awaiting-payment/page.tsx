/* eslint-disable unicorn/consistent-function-scoping */

import Link from "next/link";

import { Button } from "#shadcn/components/button";

import { CheckoutFormAccordion } from "../../components/checkout-form-accordion";

export default async function CheckoutAwaitingPaymentPage() {
  return (
    <CheckoutFormAccordion currentStep="awaiting-payment">
      <div className="flex flex-col gap-11">
        Tebrikler! Butun gerekli bilgileri doldurdunuz. Sag taraftan odemenizi
        tamamlayabilirsiniz.
      </div>

      <Button type="button" variant="outline" asChild>
        <Link className="mt-10" href="/checkout/address">
          Bilgileri Gozden Gecir
        </Link>
      </Button>
    </CheckoutFormAccordion>
  );
}
