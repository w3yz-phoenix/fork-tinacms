import Link from "next/link";

import { tinaField } from "#ui/core/hooks";

import type { TinaGraphql_PageBlocksContactInfo } from "@w3yz/cms/api";

export const ContactInfo = ({
  block,
}: {
  block: TinaGraphql_PageBlocksContactInfo;
}) => {
  return (
    <section
      data-tina-field={tinaField(block)}
      className="container flex justify-center px-5"
    >
      <div className="grid w-full max-w-[638px] grid-rows-3 items-center gap-10 rounded-lg border border-[#A0FAD5] bg-gradient-to-b from-[#DDFFF5] via-[#FFFDF1] to-[#FFFF] py-10 text-center xl:mb-10 xl:mt-32 xl:py-20">
        <div>
          <h1 className="mb-2 text-[20px] font-semibold text-[#101828]">
            {block.supportTitle}
          </h1>
          <div className="mb-5 text-xl text-[#475467]">
            {block.supportSubtitle}
          </div>
          <Link
            href="mailto:info@fruiceramics.com"
            className="text-xl font-semibold text-[#EC8065]"
          >
            {block.supportEmail}
          </Link>
        </div>
        <div>
          <h1 className="mb-2 text-[20px] font-semibold text-[#101828]">
            {block.salesTitle}
          </h1>
          <div className="mb-5 text-xl  text-[#475467]">
            {block.salesSubtitle}
          </div>
          <Link
            href="mailto:info@fruiceramics.com"
            className=" pt-5 text-xl font-semibold text-[#EC8065]"
          >
            {block.salesEmail}
          </Link>
        </div>
        <div>
          <h1 className="mb-2 text-[20px] font-semibold text-[#101828]">
            {block.phoneTitle}
          </h1>
          <div className="mb-5 text-xl text-[#475467]">
            {block.phoneSubtitle}
          </div>
          <Link
            href="tel:05313803770"
            className="pt-5 text-xl font-semibold text-[#EC8065]"
          >
            {block.phoneNumber}
          </Link>
        </div>
      </div>
    </section>
  );
};
