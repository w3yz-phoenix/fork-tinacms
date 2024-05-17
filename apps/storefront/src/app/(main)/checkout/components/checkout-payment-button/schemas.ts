import { z } from "zod";

export const CheckoutPaymentButtonFormSchema = z.object({
  termsChecked: z
    .boolean()
    .describe("On bilgilendirme kosullari")
    .default(false),
  contractChecked: z
    .boolean()
    .describe("Mesafeli satis sozlesmesi")
    .default(false),
});

export type CheckoutPaymentButtonFormType = z.infer<
  typeof CheckoutPaymentButtonFormSchema
>;
