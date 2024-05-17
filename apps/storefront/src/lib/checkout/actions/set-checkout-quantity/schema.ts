import { z } from "zod";

export const SetCheckoutLineQuantityActionSchema = z.object({
  lineId: z.string(),
  checkoutId: z.string(),
  quantity: z.number(),
});
