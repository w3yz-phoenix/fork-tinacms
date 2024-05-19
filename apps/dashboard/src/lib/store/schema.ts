import { z } from "zod";

export const StoreManifestSchema = z.object(
  {
    name: z.string(),
    slug: z.string(),
    createdAt: z
      .date()
      .refine((v) => new Date(v).toString() !== "Invalid Date")
      .transform((v) => new Date(v)),
    domains: z
      .array(
        z.object({
          fqdn: z.string(),
          type: z.enum(["builtin", "custom"]),
          disabled: z.boolean().optional().default(false),
        })
      )
      .refine((v) => v.length > 0, {
        message: "En az bir domain olmalıdır",
      }),
  },
  {
    message: "Manifest dosyasi dogru formatta degil",
  }
);

export type StoreManifestType = z.infer<typeof StoreManifestSchema>;
