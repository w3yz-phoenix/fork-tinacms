/* eslint-disable unicorn/consistent-function-scoping */
import { useCheckoutAddressUpdateMutation } from "@w3yz/ecom/api";
import { getStringIfNotEmpty, invariant, safeJsonParse } from "@w3yz/tools/lib";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";

import { setCookie } from "#storefront/lib/actions/actions.server";
import {
  getCurrentCheckout,
  revalidateCheckout,
} from "#storefront/lib/checkout/checkout.query";

import { CheckoutFormAccordion } from "../../components/checkout-form-accordion";
import { CheckoutContactFormSchema } from "../contact/schemas";

import {
  CheckoutAddressFormSchema,
  FromSaleorCheckoutAddress,
  ToSaleorInputAddress as ToSaleorAddressInputSchema,
  type CheckoutAddressFormType,
} from "./schemas";
import { CheckoutAddressForm } from "./form";

class SaleorGraphqlError extends Error {
  details: any;
  constructor(message: string, details: any) {
    super(message);
    this.name = "SaleorGraphqlError";
    this.details = details;
  }
}

export default async function CheckoutAddressPage() {
  const checkout = await getCurrentCheckout();

  const cookieValidation = await CheckoutAddressFormSchema.safeParseAsync(
    safeJsonParse(cookies().get("checkoutAddressForm")?.value)
  );

  const saleorCheckoutAddressValidation =
    await FromSaleorCheckoutAddress.safeParseAsync({
      shippingAddress: checkout.shippingAddress,
      billingAddress: checkout.billingAddress,
    });

  const existingFormValues: Partial<CheckoutAddressFormType> = {
    ...(cookieValidation.success ? cookieValidation.data : {}),
    ...(saleorCheckoutAddressValidation.success
      ? saleorCheckoutAddressValidation.data
      : {}),
  };

  async function submitCheckoutContactForm(params: CheckoutAddressFormType) {
    "use server";

    try {
      const validation = await CheckoutAddressFormSchema.spa(params);

      if (!validation.success) {
        return {
          success: false,
          validationError: validation.error.format(),
        };
      }

      const checkout = await getCurrentCheckout();

      invariant(checkout?.id, "Checkout must be defined");

      const data = validation.data;

      setCookie("checkoutAddressForm", JSON.stringify({ ...data }));

      const checkoutContactFormData =
        await CheckoutContactFormSchema.safeParseAsync(
          safeJsonParse(cookies().get("checkoutContactForm")?.value)
        );

      if (!checkoutContactFormData.success) {
        throw new Error("Checkout contact form data is not valid");
      }

      const saleorAddressInput = ToSaleorAddressInputSchema.parse({
        address: {
          ...data,
        },
        contact: {
          email: getStringIfNotEmpty(checkoutContactFormData.data.email),
          phone: getStringIfNotEmpty(checkoutContactFormData.data.phone),
        },
      });

      const response = await useCheckoutAddressUpdateMutation.fetcher({
        id: checkout.id,
        shippingAddress: {
          ...saleorAddressInput,
        },
        billingAddress: {
          ...saleorAddressInput,
        },
      })();

      if (
        (response?.checkoutBillingAddressUpdate?.errors?.length ?? 0) > 0 ||
        (response?.checkoutShippingAddressUpdate?.errors?.length ?? 0)
      ) {
        throw new SaleorGraphqlError("Failed to update address", {
          error: response,
          inputData: saleorAddressInput,
        });
      }

      revalidateCheckout();

      return {
        success: true,
      };
    } catch (error) {
      console.error(error);

      if (error instanceof SaleorGraphqlError) {
        return {
          success: false,
          name: error.name,
          error: error.message,
          details: error.details,
        };
      }

      return {
        success: false,
        error: (error as any).message,
      };
    }
  }

  async function goBack() {
    "use server";

    redirect("/checkout");
  }

  return (
    <CheckoutFormAccordion currentStep="address">
      <div className="flex flex-col gap-11">
        <CheckoutAddressForm
          values={existingFormValues}
          completeAction={submitCheckoutContactForm}
          cancelAction={goBack}
        />
      </div>
    </CheckoutFormAccordion>
  );
}
