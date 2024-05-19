import { z } from "zod";

const defineMetadata = <
  const TName extends string,
  const T extends { label: string; placeholder: string; description: string },
>(
  name: TName,
  m: T
) => ({ name, ...m });

export const storeFormCookieName = "tmp.form.store";

export const StoreFormSchema = z.object({
  name: z.string().min(3, "En az 3 karakter olmalıdır"),
  slug: z.string().min(3, "En az 3 karakter olmalıdır"),
});

export type StoreFormType = z.infer<typeof StoreFormSchema>;

export const StoreFormMetadata = {
  name: defineMetadata("name", {
    label: "Magaza Adi",
    placeholder: "Fashion Store",
    description: "Magazanizin adi",
  }),
  slug: defineMetadata("slug", {
    label: "Slug",
    placeholder: "fashion-store",
    description: "Magazanizin kod adi",
  }),
} as const;
