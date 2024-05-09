import Image from "next/image";
import Link from "next/link";
import { z } from "zod";
import { cn, cva, type VariantProps } from "#shadcn/lib/utils";

// FIXME: #W3YZ-0000: Remove this once we figure out a better way to handle classnames.
// eslint-disable-next-line tailwindcss/no-custom-classname
export const ProductCardVariants = cva("bg-white", {
  variants: {
    variant: {
      default: "text-primary",
      destructive: "text-destructive",
    },
    size: {
      sm: "size-full",
      md: "size-full",
    },
  },
  defaultVariants: {
    variant: "default",
    size: "sm",
  },
});

// The shape of the props that this component expects.
// Important: This will greatly help this component to be used by site builders.
export const ProductCardSchema = z.intersection(
  z.object({
    variantId: z.string().optional(),
    className: z.string().optional(),
    productName: z.string(),
    price: z.string(),
    imageSrc: z.string(),
    link: z.string(),
    onClickAddToCart: z.function().optional(),
    isAddingToCart: z.boolean().optional(),
  }),
  z.custom<VariantProps<typeof ProductCardVariants>>()
);

export type ProductCardProps = z.infer<typeof ProductCardSchema>;

export function ProductCard({
  className,
  variant,
  size,
  price,
  productName,
  imageSrc,
  link,
}: ProductCardProps) {
  return (
    <Link
      href={link}
      className="group flex h-full max-w-full  items-center justify-center"
    >
      <div
        className={cn(
          "flex flex-col justify-end gap-2 self-contain grow border border-[#E5E6E8] p-4 shadow-[0_2px_4px_0px_rgba(226,223,214,0.4)]",
          className,
          ProductCardVariants({ variant, size })
        )}
      >
        <Image
          loading="lazy"
          src={imageSrc}
          className={`aspect-square size-full object-scale-down p-8 transition-transform duration-300 group-hover:scale-105`}
          alt={productName}
          width={445}
          height={445}
        />
        <div className="flex w-full flex-col items-center justify-center text-center lg:flex-row lg:items-end lg:justify-between">
          <p className="mt-1 text-[18px] text-[#4C4F52]">{productName}</p>
          <p className="text-[18px] text-[#686C72]">{price}</p>
        </div>
      </div>
    </Link>
  );
}
