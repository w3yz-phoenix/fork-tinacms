import { z } from "zod";

export const ClearCheckoutActionSchema = z.object({
  lines: z.array(z.string()),
  checkoutId: z.string(),
});
