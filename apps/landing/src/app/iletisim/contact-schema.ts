import { z } from "zod";

const RE_EMAIL =
  /^(([^\s"(),.:;<>@[\\\]]+(\.[^\s"(),.:;<>@[\\\]]+)*)|(".+"))@((\[(?:\d{1,3}\.){3}\d{1,3}])|(([\dA-Za-z-]+\.)+[A-Za-z]{2,}))$/;

export const ContactSendSchema = z.object({
  firstName: z.string().min(2, { message: "İsim en az 2 karakter olmalıdır" }),
  lastName: z
    .string()
    .min(2, { message: "Soyisim en az 2 karakter olmalıdır" }),
  phone: z.string().min(10, {
    message: "Telefon numarısı 0 5XX-XXX-XX-XX formatında olmalıdır.",
  }),
  email: z.string().regex(RE_EMAIL, "Geçersiz e-posta adresi"),
  message: z.string().min(5, { message: "İsim en az 2 karakter olmalıdır" }),
});
