import { useProductListQuery } from "@w3yz/ecom/api";
import Image from "next/image";
import { cn } from "@@shadcn/lib/utils";

import type { TinaGraphql_PageBlocksProductList } from "@w3yz/cms/api";

export const ProductListBlock = ({
  block,
}: {
  block: TinaGraphql_PageBlocksProductList;
}) => {
  const productListQuery = useProductListQuery({ first: 100 });
  const products =
    productListQuery.data?.products?.edges?.map((e) => e.node) ?? [];
  const itemsPerRow = block.itemsPerRow ?? "3";
  return (
    <div>
      <h1>{block.title}</h1>
      <div
        className={cn("grid grid-cols-3", {
          "grid-cols-2": itemsPerRow === "2",
          "grid-cols-3": itemsPerRow === "3",
          "grid-cols-4": itemsPerRow === "4",
          "grid-cols-5": itemsPerRow === "5",
        })}
      >
        {products.map((product) => (
          <div key={product.id}>
            <h2>{product.name}</h2>
            <Image
              src={product.thumbnail?.url ?? ""}
              alt={product.thumbnail?.alt ?? ""}
              width={200}
              height={200}
            />
          </div>
        ))}
      </div>
    </div>
  );
};
