import { IconShoppingBag } from "@w3yz/shadcn/tabler-icons";
import Link from "next/link";

import type { TinaGraphql_GlobalConfigHeaderLinksShoppingCart } from "@w3yz/cms/api";

type CartIndicatorProps = {
  block: TinaGraphql_GlobalConfigHeaderLinksShoppingCart;
  cartItemCount: number;
  "data-tina-field"?: string;
};

export const CartIndicator = (props: CartIndicatorProps) => {
  return (
    <Link href={"/checkout"} data-tina-field={props["data-tina-field"]}>
      <button className="relative mt-1" type="button">
        {props.cartItemCount > 0 && (
          <label
            style={{
              ...(props.block.badgeColor && {
                backgroundColor: props.block.badgeColor,
              }),
            }}
            className="absolute -right-2 -top-1 m-0 flex size-[15px] items-center justify-center overflow-hidden rounded-full bg-red-500 p-0 text-[12px] text-white"
          >
            <span className="mt-px">{props.cartItemCount}</span>
          </label>
        )}

        <IconShoppingBag />
      </button>
    </Link>
  );
};
