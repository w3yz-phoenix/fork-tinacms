import Image from "next/image";
import Link from "next/link";

import { tinaField } from "#ui/core/hooks";

import type { TinaGraphql_PageBlocksSeeCollectionDesc } from "@w3yz/cms/api";

export const SeeCollectionDesc = ({
  block,
}: {
  block: TinaGraphql_PageBlocksSeeCollectionDesc;
}) => {
  return (
    <section
      className="container flex flex-col gap-5 sm:flex-row"
      data-tina-field={tinaField(block)}
    >
      <div className="flex flex-col-reverse sm:flex-col">
        {block.photos && block.photos.length > 1 && (
          <Image
            src={block?.photos[0]?.image?.src || ""}
            width={815}
            height={527}
            alt={block?.photos[0]?.image?.alt || "image"}
            className="object-cover min-w-full h-2/3"
          />
        )}
        <div className="max-w-[510px] break-words text-left font-bold flex flex-col gap-2 my-8 text-xl md:text-5xl">
          <p>{block.title}</p>
          <p className="text-[20px] font-medium text-[#656565] line-clamp-5 ">
            {block.subTitle}
          </p>
          <Link
            href={`${block.link?.href || "/"}`}
            className="max-w-[330px] text-sm underline mt-3"
          >
            {block.link?.name || "Koleksiyonu Gör"}
          </Link>
        </div>
      </div>
      <div>
        {block.photos && block.photos.length > 1 && (
          <Image
            src={block?.photos[1]?.image?.src || ""}
            width={521}
            height={856}
            alt={block?.photos[1]?.image?.alt || "image"}
            className="object-cover w-full h-full"
          />
        )}
      </div>
    </section>
  );
};
