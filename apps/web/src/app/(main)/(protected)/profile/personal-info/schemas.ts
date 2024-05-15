import { z } from "zod";

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

export const ProfilePersonalInfoFormSchema = z.object({
  firstName: z.string(),
  lastName: z.string(),
  email: z.string().regex(RE_EMAIL, "Geçersiz e-posta adresi"),
  phone: z.string().regex(RE_PHONE, {
    message: "Telefon numarası 5XX-XXX-XX-XX formatında olmalıdır.",
  }),
});

export type ProfilePersonalInfoFormType = z.infer<
  typeof ProfilePersonalInfoFormSchema
>;

export const ProfilePersonalInfoFormMetadata: {
  [K in keyof ProfilePersonalInfoFormType]: ReturnType<typeof defineMetadata>;
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
} as const;
