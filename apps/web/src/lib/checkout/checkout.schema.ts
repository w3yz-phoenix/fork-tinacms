import { z } from "zod";

import { ProductPageStateSchema } from "../product/product.utils";

export const AddItemToCartSchema = ProductPageStateSchema.pick({
  quantity: true,
  variant: true,
  product: true,
  cartela: true,
});

export const GenericResponseSchema = z
  .object({
    success: z.boolean(),
    message: z.string().optional(),
    iteration: z.number().default(1).optional(),
  })
  .optional();

export type GenericResponse = z.infer<typeof GenericResponseSchema>;
