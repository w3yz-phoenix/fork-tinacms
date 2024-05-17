import { z } from "zod";

export const DeleteCheckoutLinesActionSchema = z.object({
  lines: z.array(z.string()),
  checkoutId: z.string(),
});
