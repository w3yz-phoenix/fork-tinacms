import { z } from "zod";
import {
  SaleorGraphql_CountryCode,
  type SaleorGraphql_AddressInput,
  type SaleorGraphql_CheckoutFindQuery,
} from "@w3yz/ecom/api";
import { getStringIfNotEmpty, publicEnvironment } from "@w3yz/tools/lib";

import type { Get } from "type-fest";

const defineMetadata = <
  const TName extends string,
  const T extends { label: string; placeholder: string; description: string },
>(
  name: TName,
  m: T
) => ({ name, ...m });

const RE_EMAIL =
  /^(([^\s"(),.:;<>@[\\\]]+(\.[^\s"(),.:;<>@[\\\]]+)*)|(".+"))@((\[(?:\d{1,3}\.){3}\d{1,3}])|(([\dA-Za-z-]+\.)+[A-Za-z]{2,}))$/;

const RE_PHONE = /^5\d{2}[\s-]?\d{3}(?:[\s-]?\d{2}){2}$/;

export const ProfileAddressFormSchema = z.object({
  firstName: z.string(),
  lastName: z.string(),
  email: z.string().regex(RE_EMAIL, "Geçersiz e-posta adresi"),
  phone: z.string().regex(RE_PHONE, {
    message: "Telefon numarası 5XX-XXX-XX-XX formatında olmalıdır.",
  }),
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
    address: ProfileAddressFormSchema,
  })
  .transform(({ address }) => {
    return {
      firstName: address.firstName,
      lastName: address.lastName,
      countryArea: address.countryArea,
      city: address.district,
      streetAddress1: address.streetAddress1,
      streetAddress2: address.streetAddress2,
      postalCode: address.postalCode,
      phone: address.phone,
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

export const FromSaleorProfileAddress = z
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
      email: getStringIfNotEmpty(shippingAddress?.email),
      phone: getStringIfNotEmpty(shippingAddress?.phone),
      countryArea: getStringIfNotEmpty(shippingAddress?.countryArea),
      district: getStringIfNotEmpty(shippingAddress?.city),
      streetAddress1: getStringIfNotEmpty(shippingAddress?.streetAddress1),
      streetAddress2: getStringIfNotEmpty(shippingAddress?.streetAddress2),
      postalCode: getStringIfNotEmpty(shippingAddress?.postalCode),
    } satisfies Partial<ProfileAddressFormType>;
  });

export type ProfileAddressFormType = z.infer<typeof ProfileAddressFormSchema>;

export const ProfileAddressFormMetadata: {
  [K in keyof ProfileAddressFormType]: ReturnType<typeof defineMetadata>;
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
  email: defineMetadata("email", {
    label: "E-Posta",
    placeholder: "E-Posta",
    description: "E-Posta",
  }),
  phone: defineMetadata("phone", {
    label: "Telefon",
    placeholder: "Telefon",
    description: "Telefon",
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
