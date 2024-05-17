import { z } from "zod";

const RE_EMAIL =
  /^(([^\s"(),.:;<>@[\\\]]+(\.[^\s"(),.:;<>@[\\\]]+)*)|(".+"))@((\[(?:\d{1,3}\.){3}\d{1,3}])|(([\dA-Za-z-]+\.)+[A-Za-z]{2,}))$/;

const RE_PHONE = /^5\d{2}[\s-]?\d{3}(?:[\s-]?\d{2}){2}$/;

const defineMetadata = <
  const TName extends string,
  const T extends { label: string; placeholder: string; description: string },
>(
  name: TName,
  m: T
) => ({ name, ...m });

export const CheckoutContactFormSchema = z.object({
  email: z.string().regex(RE_EMAIL, "Geçersiz e-posta adresi"),
  phone: z.string().regex(RE_PHONE, {
    message: "Telefon numarası 5XX-XXX-XX-XX formatında olmalıdır.",
  }),
});

export type CheckoutContactFormType = z.infer<typeof CheckoutContactFormSchema>;

export const CheckoutContactFormMetadata = {
  email: defineMetadata("email", {
    label: "E-Posta",
    placeholder: "shadcn",
    description: "E-posta adresiniz",
  }),
  phone: defineMetadata("phone", {
    label: "Telefon numarasi",
    placeholder: "shadcn",
    description: "Telefon numaranız",
  }),
} as const;
