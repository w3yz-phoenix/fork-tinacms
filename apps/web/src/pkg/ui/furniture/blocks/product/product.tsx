import Image from "next/image";
import Link from "next/link";
import { tinaField } from "tinacms/dist/react";
import { useState, useEffect } from "react";

import type { TinaGraphql_PageBlocksProduct } from "@w3yz/cms/api";

export const ProductBlock = ({
  block,
}: {
  block: TinaGraphql_PageBlocksProduct;
}) => {
  const [category, setCategory] = useState<string>();
  useEffect(() => {
    block?.productsCategory
      ?.slice(0, 1)
      .map((item) => setCategory(item?.categoryName));
  }, [block.productsCategory]);
  return (
    <section
      className="flex w-full justify-center py-[150px]"
      data-tina-field={tinaField(block)}
    >
      <div className="container mx-auto flex flex-col items-center px-5 lg:px-[100px]">
        <div className="flex flex-row gap-5 text-[13px] md:text-[22px] xl:text-[28px]">
          {block.productsCategory?.map((item, index) => (
            <button
              onClick={() => setCategory(item?.categoryName)}
              key={index}
              className={`${
                category === item?.categoryName
                  ? "font-bold text-[#292929]"
                  : "font-normal text-[#BDBDBD]"
              }`}
            >
              {item?.categoryName}
            </button>
          ))}
        </div>
        <div>
          <div className="grid grid-cols-1 gap-[30px] pt-[60px] sm:grid-cols-2 xl:grid-cols-3">
            {block?.productsCategory?.map(
              (item) =>
                item?.categoryName === category &&
                item?.products?.map((item, index) => (
                  <Link
                    href={item?.productLink ?? ""}
                    key={index}
                    className="flex w-full max-w-[530px] flex-col border border-DEFAULT"
                  >
                    <Image
                      src={item?.image ?? ""}
                      width={530}
                      height={395}
                      alt={""}
                    />
                    <p className="pb-[13px] pt-[8px] text-center text-[12px] font-normal text-[#292929]">
                      {item?.productName}
                    </p>
                  </Link>
                ))
            )}
          </div>
        </div>
        <Link
          href={block.link?.href ?? ""}
          className="flex flex-row gap-x-1 pt-[40px] text-center text-[16px] font-medium text-[#464646]"
        >
          {block.link?.name ?? "Tüm Ürünleri Göster"}
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            fill="none"
            viewBox="0 0 24 24"
          >
            <g
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              clipPath="url(#clip0_2763_1718)"
            >
              <path stroke="#464646" d="M17 7L7 17"></path>
              <path stroke="#000" d="M8 7h9v9"></path>
            </g>
            <defs>
              <clipPath id="clip0_2763_1718">
                <path fill="#fff" d="M0 0H24V24H0z"></path>
              </clipPath>
            </defs>
          </svg>
        </Link>
      </div>
    </section>
  );
};
