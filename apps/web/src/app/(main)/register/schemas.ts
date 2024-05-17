import { z } from "zod";

const RE_EMAIL =
  /^(([^\s"(),.:;<>@[\\\]]+(\.[^\s"(),.:;<>@[\\\]]+)*)|(".+"))@((\[(?:\d{1,3}\.){3}\d{1,3}])|(([\dA-Za-z-]+\.)+[A-Za-z]{2,}))$/;

// const RE_PHONE = /^5\d{2}[\s-]?\d{3}(?:[\s-]?\d{2}){2}$/;

const defineMetadata = <
  const TName extends string,
  const T extends { label: string; placeholder: string; description: string },
>(
  name: TName,
  m: T
) => ({ name, ...m });

export const RegisterFormSchema = z.object({
  firstName: z.string().min(2, "Adınızı giriniz."),
  lastName: z.string().min(2, "Soyadınızı giriniz."),
  email: z.string().regex(RE_EMAIL, "Geçersiz e-posta adresi"),
  password: z.string().min(8, "Şifreniz en az 6 karakter olmalıdır"),
});

export type RegisterFormType = z.infer<typeof RegisterFormSchema>;

export const RegisterFormMetadata = {
  firstName: defineMetadata("firstName", {
    label: "Ad",
    placeholder: "Ad",
    description: "",
  }),
  lastName: defineMetadata("lastName", {
    label: "Soyad",
    placeholder: "Soyad",
    description: "",
  }),
  email: defineMetadata("email", {
    label: "E-Posta",
    placeholder: "E-posta",
    description: "",
  }),
  password: defineMetadata("password", {
    label: "Şifre",
    placeholder: "Şifre",
    description: "",
  }),
} as const;
