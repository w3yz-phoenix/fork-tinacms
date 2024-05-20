import Image from "next/image";
import Link from "next/link";

import { tinaField } from "#ui/core/hooks";

import type { TinaGraphql_PageBlocksFashionTextWithPhoto } from "@w3yz/cms/api";

export const FashionTextWithPhoto = ({
  block,
}: {
  block: TinaGraphql_PageBlocksFashionTextWithPhoto;
}) => {
  return (
    <section
      data-tina-field={tinaField(block)}
      className="max-w-[1200px] mx-auto px-5"
    >
      <div className="grid grid-cols-1 sm:grid-cols-2">
        <div className={`w-full lg:min-h-[500px] ${block.isReversed && "order-last"}`}>
          <Image
            src={block.photo || "/"}
            alt={block?.imageAlt || "/"}
            width={600}
            height={511}
            className="min-h-[300px] min-w-full object-cover lg:h-[511px] h-full"
          />
        </div>
        <div className="w-full lg:min-h-[500px] bg-[#F4F8FB] p-5 lg:px-20 lg:py-10 flex flex-col gap-5 justify-center">
          <label className="text-[28px] sm:text-[32px] md:text-[40px] text-black font-semibold">{block.title}</label>
          <p className="text-black text-[16px] md:text-[20px]">
            {block.subTitle}
          </p>
        </div>
      </div>
    </section>
  );
};
