import { z } from "zod";

import { createQueryStringLinkGenerator } from "../state-link.utils";

export const ProductPageStateSchema = z.object({
  category: z.coerce.string().optional(),
  slug: z.coerce.string().optional(),
  product: z.coerce.string().optional(),
  variant: z.coerce.string().optional(),
  quantity: z.coerce.number().int().min(1).max(100).default(1),
  currentImageId: z.coerce.string().optional(),
  cartela: z.coerce.string().optional(),
  infoTab: z.coerce.string().default("product-info"),
  cartelaDrawer: z.coerce
    .string()
    .toLowerCase()
    .transform((value) => value === "true")
    .pipe(z.boolean().default(false)),
});

export const getProductStateLinkGenerator = (canonicalPath: string) => {
  return createQueryStringLinkGenerator(canonicalPath, ProductPageStateSchema);
};

export type ProductPageStateType = z.infer<typeof ProductPageStateSchema>;
