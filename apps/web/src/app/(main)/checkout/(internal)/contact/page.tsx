"use client";

import { Input } from "#shadcn/components/input";
import { ServerActionForm } from "#ui/core/components/server-action-form/server-action-form";
import { useFormStatus } from "react-dom";

import { SubmitButton } from "#web/components/submit-button";

import { CheckoutFormAccordion } from "../../components/checkout-form-accordion";

import { checkoutContactPageSubmitFormAction } from "./actions";

export default function CheckoutContactPage() {
  return (
    <CheckoutFormAccordion currentStep="contact">
      <div className="flex flex-col gap-11">
        <div className="flex flex-col gap-6">
          <p className="text-sm font-medium leading-tight text-[#656565]">
            Faturanızın ulaşması için mail adresinizi girmeniz gerekmektedir.
          </p>
          <ServerActionForm
            action={checkoutContactPageSubmitFormAction}
            fields={{}}
          >
            <Input name="email" />
            <Input name="phone" />
            <div className="self-end">
              <SubmitButton variant="default">Ileri</SubmitButton>
            </div>
          </ServerActionForm>
        </div>
      </div>
    </CheckoutFormAccordion>
  );
}
