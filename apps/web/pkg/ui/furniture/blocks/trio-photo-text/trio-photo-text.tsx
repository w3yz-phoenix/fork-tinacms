import Image from "next/image";
import Link from "next/link";

import { tinaField } from "#ui/core/hooks";

import type { TinaGraphql_PageBlocksTrioPhotoText } from "@w3yz/cms/api";

export const TrioPhotoText = ({
  block,
}: {
  block: TinaGraphql_PageBlocksTrioPhotoText;
}) => {
  return (
    <section
      data-tina-field={tinaField(block)}
      className="flex justify-center bg-[F6F6F6] px-6 py-[8.3%]"
    >
      <div className="flex flex-col items-center">
        <div className="mb-3 text-[#00C48C]"> {block.title}</div>
        <div className="mb-3 text-[2rem] font-medium text-[292929] md:text-[3.125rem] xl:mb-6">
          {block.subTitle}
        </div>
        <p className="mx-auto mb-5 max-w-[772px] text-center text-[656565] md:text-[1.25rem]">
          {block.description}
        </p>
        <Link href={`${block.link?.href || "/"}`}>
          <button
            type="button"
            className="flex items-center justify-center rounded-lg border border-[#D7DAE0] px-7 py-2 font-medium text-[#565E73] hover:border-[#8A94A6] hover:bg-[#F6F6F6] hover:text-[#24262D] hover:shadow-[0px_0px_0px_2px_rgba(215,218,224,0.80)]"
          >
            <span> {block.link?.name || "Devamı"}</span>
          </button>
        </Link>

        <div className="3xl:mt-[100px] mt-[4%] flex flex-col gap-5 sm:flex-row">
          {block.photos?.map(
            (item, index) =>
              item && (
                <div key={index} data-tina-field={tinaField(item)}>
                  <Image
                    src={item?.image?.src || "/"}
                    alt={item?.image?.alt || "/"}
                    width={436}
                    height={404}
                    className="h-[200px] object-cover lg:h-[404px]"
                  />
                </div>
              )
          )}
        </div>
      </div>
    </section>
  );
};
