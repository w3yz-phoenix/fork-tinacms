import Image from "next/image";
import Link from "next/link";

import { tinaField } from "#ui/core/hooks";

import type { TinaGraphql_PageBlocksFashionStrip } from "@w3yz/cms/api";

export const FashionStrip = ({
  block,
}: {
  block: TinaGraphql_PageBlocksFashionStrip;
}) => {
  return (
    <section
      className="bg-[#F6F6F6] p-10 container"
      data-tina-field={tinaField(block)}
    >
      <div className="flex flex-col justify-center items-center bg-white gap-y-4 p-[60px]">
        <p className="max-w-[772px] line-clamp-5 text-center text-[24px] font-semibold">
          {block.strip}
        </p>
        <p className="text-center text-[20px] font-medium line-clamp-1">{block.author}</p>
      </div>
    </section>
  );
};
