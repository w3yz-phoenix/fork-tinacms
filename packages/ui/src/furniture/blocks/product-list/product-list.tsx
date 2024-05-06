import type { TinaGraphql_PageBlocksProductList } from "@w3yz/cms/api";

export const ProductListBlock = ({
  block,
}: {
  block: TinaGraphql_PageBlocksProductList;
}) => {
  return (
    <div>
      <h1>Urunlerrrrr</h1>
      <h5>{block.title}</h5>
    </div>
  );
};
