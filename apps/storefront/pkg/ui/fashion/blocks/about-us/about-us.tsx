import Image from "next/image";

import { tinaField } from "#ui/core/hooks";

import type { TinaGraphql_PageBlocksFashionAboutUs } from "@w3yz/cms/api";

export const FashionAboutUs = ({
  block,
}: {
    block: TinaGraphql_PageBlocksFashionAboutUs;
}) => {
  return (
    <section data-tina-field={tinaField(block)} className="w-full">
      <div className="absolute left-0 top-0 w-full -z-10">
        <div className="w-full relative max-h-[533px]">
          <Image
            src={block?.backGroundImage || ""}
            alt={block?.imageAlt || "/"}
            width={1440}
            height={533}
            className="min-h-[300px] min-w-full object-cover lg:h-[533px] h-full"
          />
        </div>
      </div>

      <div className="max-w-[600px] mx-auto pt-0 p-5 md:p-0 z-50 mt-2 lg:mt-24">
        <div className="p-5 text-white flex flex-col gap-5">
          <label className="text-2xl md:text-4xl font-bold">{block?.title}</label>
          <p className="font-medium">
            {block?.subTitleAboutUs}
          </p>
        </div>
        <div className="md:mt-5 lg:mt-24">
          <Image
            src={block?.photoContent || ""}
            alt={block?.imageAlt || "/"}
            width={600}
            height={366}
            className="min-h-[300px] min-w-full object-cover lg:h-[366px] h-full"
          />

          <p className="text-black font-medium mt-7 block">
            {block?.aboutUsTitle}
          </p>

          <p className="text-[#525252] mt-11">
            {block?.aboutUsText}
          </p>
        </div>
      </div>
    </section>
  );
};
