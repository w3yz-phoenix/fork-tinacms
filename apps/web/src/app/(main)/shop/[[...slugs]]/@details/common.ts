import { z } from "zod";

const RE_EMAIL =
  /^(([^\s"(),.:;<>@[\\\]]+(\.[^\s"(),.:;<>@[\\\]]+)*)|(".+"))@((\[(?:\d{1,3}\.){3}\d{1,3}])|(([\dA-Za-z-]+\.)+[A-Za-z]{2,}))$/;

export const LoginRequestSchema = z.object({
  email: z.string().regex(RE_EMAIL, "Geçersiz e-posta adresi"),
  password: z.string().min(8, "Şifre en az 8 karakter olmalıdır"),
});

export type LoginRequestSchemaType = z.infer<typeof LoginRequestSchema>;

export const EmailSchema = z
  .string()
  .regex(RE_EMAIL, "Geçersiz e-posta adresi");

export const RegisterRequestSchema = z.object({
  fullName: z.coerce.string().min(5, "Kontrol Edin!"),
  email: EmailSchema,
  password: z.coerce.string().min(8, "Şifre en az 8 karakter olmalıdır"),
});

export type RegisterRequestSchemaType = z.infer<typeof RegisterRequestSchema>;

export const ResetPasswordRequestSchema = z
  .object({
    oldPassword: z.string().min(8, "Şifre en az 8 karakter olmalıdır"),
    newPassword: z.string().min(8, "Şifre en az 8 karakter olmalıdır"),
    passwordRety: z.string(),
  })
  .refine((data) => data.newPassword === data.passwordRety, {
    message: "Passwords don't match",
    path: ["passwordRety"], // path of error
  });

export type ResetPasswordRequestSchemaType = z.infer<
  typeof ResetPasswordRequestSchema
>;

export const ContactRequestSchema = z.object({
  name: z.string().min(3, "Ad en az 2 karakter olmalıdır."),
  surname: z.string().min(2, "Soyad en az 2 karakter olmalıdır"),
  phone: z.string(),
  email: z.string().regex(RE_EMAIL, "Geçersiz e-posta adresi"),
  sector: z.string().min(3, "Lütfen kontrol edin."),
  companyName: z.string().min(3, "Lütfen kontrol edin."),
  country: z.string().min(3, "Lütfen kontrol edin."),
  city: z.string().min(3, "Lütfen kontrol edin."),
  message: z.string().min(10, "Lütfen kontrol edin."),
});

export type ContactRequestSchemaType = z.infer<typeof ContactRequestSchema>;

export const PersonalInfoRequestSchema = z.object({
  firstName: z.coerce
    .string()
    .min(2, { message: "Ad en az 2 karakter olmalıdır" })
    .max(20, { message: "Ad en fazla 20 karakter olabilir." })
    .optional(),
  lastName: z.coerce
    .string()
    .min(2, { message: "Soyad en az 2 karakter olmalıdır" })
    .max(20, { message: "Soyad en fazla 20 karakter olabilir." })
    .optional(),
  phoneNumber: z.coerce
    .string()
    .regex(/^\d+$/, "Telefon numarası sadece rakamlardan oluşmalıdır.")
    .min(10, { message: "Telefon numarası en az 10 karakter olmalıdır." })
    .max(20, { message: "Soyad en fazla 20 karakter olabilir." })
    .optional(),
  birthDay: z.coerce.string().optional(),
  birthMonth: z.coerce.string().optional(),
  birthYear: z.coerce.string().optional(),
  gender: z.coerce.string().optional(),
});

export type PersonalInfoRequestSchemaType = z.infer<
  typeof PersonalInfoRequestSchema
>;
