import Image from "next/image";
import Link from "next/link";

import { tinaField } from "#ui/core/hooks";

import type { TinaGraphql_PageBlocksBlogCardHome } from "@w3yz/cms/api";

export const BlogCard = ({
  block,
}: {
  block: TinaGraphql_PageBlocksBlogCardHome;
}) => {
  return (
    <section
      data-tina-field={tinaField(block)}
      className="container mx-auto mt-[144px] px-5"
    >
      <label className="mb-8 block p-4 text-[32px] text-[#292929]">
        {block.mainTitle}
      </label>

      <div className="grid grid-cols-1 gap-7 md:grid-cols-2">
        {block.blogCards?.map((item, index) => (
          <div key={index}>
            <Link href={`/${item?.link}` || "/"}>
              <Image
                src={item?.image?.src || ""}
                width={650}
                height={650}
                alt={item?.image?.alt || ""}
                className="max-h-[500px] w-full max-w-full object-cover"
              />
            </Link>
            <Link
              href={`/${item?.link}` || "/"}
              className="mb-3 mt-6 block text-[20px] font-medium text-[#292929]"
            >
              {item?.blogTitle || ""}
            </Link>
            <p className="text-[16px] text-[#656565]">
              {item?.description || ""}
            </p>
          </div>
        ))}
      </div>
    </section>
  );
};
