"use server";
import { Resend } from "resend";
import { z } from "zod";

import { ContactSendSchema } from "./contact-schema";
import { resendApiKey } from "./environment.server";
import { MessageContent } from "./message-content";
import { GenericResponseSchema } from "./schema";

const resend = new Resend(resendApiKey);

export const sendContactEmailForm = async (
  previousState: z.infer<typeof GenericResponseSchema>,
  formData: FormData
) => {
  try {
    const parameters = await ContactSendSchema.parseAsync(
      Object.fromEntries(formData)
    );
    await resend.emails.send({
      from: "w3yz@dev.nepjua.org",
      to: "se.linertan94@gmail.com",
      subject: "Müşterinizden bir mesajınız var",
      text: parameters.message,
      react: MessageContent({
        name: parameters.firstName,
        lastName: parameters.lastName,
        email: parameters.email,
        phone: parameters.phone,
        message: parameters.message,
      }),
    });

    return {
      success: true,
      message: "Mailniz Başarıyla Gönderilmiştir.",
      resetForm: true,
    };
  } catch (error: Error | any) {
    console.error(error);

    return {
      success: false,
      message: error?.message ?? "Lütfen Tekrar Deneyin.",
    };
  }
};
