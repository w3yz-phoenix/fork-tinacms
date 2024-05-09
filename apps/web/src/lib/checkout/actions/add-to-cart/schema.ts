import { z } from "zod";

export const AddItemToCartSchema = z.object({
  product: z.string(),
  variant: z.string(),
  quantity: z.number().int().min(1).max(100),
});
