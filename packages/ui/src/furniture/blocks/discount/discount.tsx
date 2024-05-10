import Link from "next/link";
import Image from "next/image";

import { tinaField } from "#ui/core/hooks";

import type { TinaGraphql_PageBlocksDiscounts } from "@w3yz/cms/api";

export const DiscountsBlock = ({
  block,
}: {
  block: TinaGraphql_PageBlocksDiscounts;
}) => {
  const { items } = block;
  return (
    <section className="mx-auto mt-[144px] grid max-w-[1356px] grid-cols-1 gap-8 px-5 sm:grid-cols-2 xl:grid-cols-3">
      {items?.map((item, index) => {
        if (!item) return null;
        return (
          <Link
            href={item?.link || "/"}
            className="flex items-center gap-4 bg-[#F6F6F6] sm:gap-6"
            data-tina-field={tinaField(item)}
            key={index}
          >
            <div>
              <Image
                src={item?.image?.src || "/"}
                alt={item?.image?.alt || "/"}
                width={213}
                height={232}
                className="max-w-[150px] object-cover lg:max-h-[232px] lg:max-w-[213px]"
              />
            </div>
            <div>
              <label className="mb-3 text-[18px] font-bold text-[#F93A61] md:text-[24px]">
                {item.discountRatio}
              </label>
              <p className="text-[14px] text-[#656565] md:text-[16px]">
                {item.title}
              </p>
            </div>
          </Link>
        );
      })}
    </section>
  );
};
