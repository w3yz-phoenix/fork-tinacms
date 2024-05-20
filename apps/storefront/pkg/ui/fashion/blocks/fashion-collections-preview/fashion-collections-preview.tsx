import Image from "next/image";
import Link from "next/link";

import { tinaField } from "#ui/core/hooks";

import type { TinaGraphql_PageBlocksFashionCollectionsPreview } from "@w3yz/cms/api";

export const FashionCollectionsPreview = ({
  block,
}: {
  block: TinaGraphql_PageBlocksFashionCollectionsPreview;
}) => {
  return (
    <section
      data-tina-field={tinaField(block)}
      className="container mx-auto px-5"
    >
      <div className="mb-7 flex flex-col items-center justify-between gap-4 sm:mb-16 sm:flex-row">
        <label className="text-[32px] font-bold text-black sm:text-[48px] md:text-[52px]">
          {block.title}
        </label>
        <Link
          href={`${block.linkCollection}`}
          className="text-[16px] text-black underline sm:text-[20px]"
        >
          {block.linkTitle}
        </Link>
      </div>

      <div className="grid grid-cols-1 gap-10 md:grid-cols-2">
        {block.collectionPhotos?.map(
          (item, index) =>
            item && (
              <Link
                href={`${item.imageLink}`}
                key={index}
                data-tina-field={tinaField(item)}
              >
                <Image
                  src={item?.image || "/"}
                  alt={item?.image || "/"}
                  width={436}
                  height={404}
                  className="h-[200px] w-full object-cover lg:h-[595px]"
                />
              </Link>
            )
        )}
      </div>
    </section>
  );
};
