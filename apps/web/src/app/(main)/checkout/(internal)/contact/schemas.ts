import { z } from "zod";

export const CheckoutContactPageSubmitFormActionSchema = z.object({
  email: z.string().email(),
  phone: z.string().min(10).max(10),
});
