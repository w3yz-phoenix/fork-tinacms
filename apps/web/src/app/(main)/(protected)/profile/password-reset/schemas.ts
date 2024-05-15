import { z } from "zod";

const defineMetadata = <
  const TName extends string,
  const T extends { label: string; placeholder: string; description: string },
>(
  name: TName,
  m: T
) => ({ name, ...m });

export const ProfilePasswordResetFormSchema = z.object({
  oldPassword: z.string().min(8, "Şifre en az 8 karakter olmalıdır"),
  newPassword: z.string().min(8, "Şifre en az 8 karakter olmalıdır"),
  passwordRety: z.string(),
});

export type ProfilePersonalInfoFormType = z.infer<
  typeof ProfilePasswordResetFormSchema
>;

export const ProfilePasswordResetFormMetadata: {
  [K in keyof ProfilePersonalInfoFormType]: ReturnType<typeof defineMetadata>;
} = {
  oldPassword: defineMetadata("firstName", {
    label: "Şu Anki Parola",
    placeholder: "Şu Anki Parola",
    description: "",
  }),
  newPassword: defineMetadata("lastName", {
    label: "Yeni Parola",
    placeholder: "Yeni Parola",
    description:
      "Şifreniz en az 8 karakter olmalı ve en az 1 harf veya rakam içermelidir.",
  }),
  passwordRety: defineMetadata("email", {
    label: "E-Yeni Parola",
    placeholder: "Yeni Parola",
    description: "",
  }),
} as const;
