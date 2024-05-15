import { z } from "zod";

const RE_EMAIL =
  /^(([^\s"(),.:;<>@[\\\]]+(\.[^\s"(),.:;<>@[\\\]]+)*)|(".+"))@((\[(?:\d{1,3}\.){3}\d{1,3}])|(([\dA-Za-z-]+\.)+[A-Za-z]{2,}))$/;

const defineMetadata = <
  const TName extends string,
  const T extends { label: string; placeholder: string; description: string },
>(
  name: TName,
  m: T
) => ({ name, ...m });

export const LoginFormSchema = z.object({
  email: z.string().regex(RE_EMAIL, "Geçersiz e-posta adresi"),
  password: z.string().min(8, "Şifreniz en az 6 karakter olmalıdır"),
});

export type LoginFormType = z.infer<typeof LoginFormSchema>;

export const LoginFormMetadata = {
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
