import { z } from "zod";
import {
  SaleorGraphql_CountryCode,
  type SaleorGraphql_AddressInput,
  type SaleorGraphql_CheckoutFindQuery,
} from "@w3yz/ecom/api";
import { getStringIfNotEmpty, publicEnvironment } from "@w3yz/tools/lib";

import type { Get } from "type-fest";

import { CheckoutContactFormSchema } from "../contact/schemas";

const defineMetadata = <
  const TName extends string,
  const T extends { label: string; placeholder: string; description: string },
>(
  name: TName,
  m: T
) => ({ name, ...m });

export const CheckoutAddressFormSchema = z.object({
  firstName: z.string(),
  lastName: z.string(),
  countryArea: z
    .string()
    .describe("Sehir => Il => Saleor'da countryArea olarak geciyor."),
  district: z.string().describe("Ilce => Saleor'da city olarak geciyor."),
  streetAddress1: z.string(),
  streetAddress2: z.string(),
  postalCode: z.string(),
});

export const ToSaleorInputAddress = z
  .object({
    address: CheckoutAddressFormSchema,
    contact: CheckoutContactFormSchema,
  })
  .transform(({ address, contact }) => {
    return {
      firstName: address.firstName,
      lastName: address.lastName,
      countryArea: address.countryArea,
      city: address.district,
      streetAddress1: address.streetAddress1,
      streetAddress2: address.streetAddress2,
      postalCode: address.postalCode,
      phone: contact.phone,
      cityArea: undefined,
      country: SaleorGraphql_CountryCode.Tr,
      companyName: undefined,
      metadata: [
        {
          key: "storefrontUrl",
          value: publicEnvironment.ecom.url,
        },
      ],
    } satisfies SaleorGraphql_AddressInput;
  });

export const FromSaleorCheckoutAddress = z
  .object({
    shippingAddress:
      z.custom<
        Get<SaleorGraphql_CheckoutFindQuery, "checkout.shippingAddress">
      >(),
    billingAddress:
      z.custom<
        Get<SaleorGraphql_CheckoutFindQuery, "checkout.shippingAddress">
      >(),
  })
  .transform(({ shippingAddress }) => {
    return {
      firstName: getStringIfNotEmpty(shippingAddress?.firstName),
      lastName: getStringIfNotEmpty(shippingAddress?.lastName),
      countryArea: getStringIfNotEmpty(shippingAddress?.countryArea),
      district: getStringIfNotEmpty(shippingAddress?.city),
      streetAddress1: getStringIfNotEmpty(shippingAddress?.streetAddress1),
      streetAddress2: getStringIfNotEmpty(shippingAddress?.streetAddress2),
      postalCode: getStringIfNotEmpty(shippingAddress?.postalCode),
    } satisfies Partial<CheckoutAddressFormType>;
  });

export type CheckoutAddressFormType = z.infer<typeof CheckoutAddressFormSchema>;

export const CheckoutAddressFormMetadata: {
  [K in keyof CheckoutAddressFormType]: ReturnType<typeof defineMetadata>;
} = {
  firstName: defineMetadata("firstName", {
    label: "Ad",
    placeholder: "Adiniz",
    description: "Adiniz",
  }),
  lastName: defineMetadata("lastName", {
    label: "Soyad",
    placeholder: "Soyadiniz",
    description: "Soyadiniz",
  }),
  countryArea: defineMetadata("countryArea", {
    label: "Il",
    placeholder: "Il",
    description: "Il",
  }),
  district: defineMetadata("district", {
    label: "Ilce",
    placeholder: "Ilce",
    description: "Ilce",
  }),
  streetAddress1: defineMetadata("streetAddress1", {
    label: "Adres",
    placeholder: "Adres",
    description: "Adres",
  }),
  streetAddress2: defineMetadata("streetAddress2", {
    label: "Adres 2",
    placeholder: "Adres 2",
    description: "Adres 2",
  }),
  postalCode: defineMetadata("postalCode", {
    label: "Posta Kodu",
    placeholder: "Posta Kodu",
    description: "Posta Kodu",
  }),
} as const;
