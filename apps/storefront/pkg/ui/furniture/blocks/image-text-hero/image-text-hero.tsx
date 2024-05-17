import Image from "next/image";
import Link from "next/link";

import { tinaField } from "#ui/core/hooks";

import type { TinaGraphql_PageBlocksImageTextHero } from "@w3yz/cms/api";

export const ImageTextHero = ({
  block,
}: {
  block: TinaGraphql_PageBlocksImageTextHero;
}) => {
  return (
    <section
      className="container mx-auto mt-[150px] flex flex-col-reverse items-center justify-between gap-7 px-5 md:flex-row"
      data-tina-field={tinaField(block)}
    >
      <div className="w-full md:max-w-[550px]">
        <Image
          src={block.image?.src || ""}
          width={1100}
          height={1272}
          alt={block.image?.alt || ""}
          objectFit="cover"
          className="w-full"
        />
      </div>
      <div className="max-w-[510px] text-left">
        <span className="mb-3 block text-[16px] text-[#00C48C]">
          {block.title}
        </span>
        <label className="mb-5 block text-[32px] font-bold leading-tight text-[#292929] md:text-[50px]">
          {block.subTitle}
        </label>
        <p className="text-[16px] line-clamp-[10] text-[#656565] md:text-[20px]">
          {block.description}
        </p>
        <div className="flex justify-center">
          <Link
            href={`${block.link?.href || "/"}`}
            className="flex items-center justify-center mt-7 max-w-[230px] rounded-lg border border-[#D7DAE0] px-3 py-2 font-medium text-[#565E73] hover:border-[#8A94A6] hover:bg-[#F6F6F6] hover:text-[#24262D] hover:shadow-[0px_0px_0px_2px_rgba(215,218,224,0.80)]"
          >
            {block.link?.name || "Devamı"}
          </Link>
        </div>
      </div>
    </section>
  );
};
