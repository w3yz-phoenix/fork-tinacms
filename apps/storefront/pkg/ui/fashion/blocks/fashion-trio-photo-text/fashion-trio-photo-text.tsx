import Image from "next/image";

import { tinaField } from "#ui/core/hooks";

import type { TinaGraphql_PageBlocksFashionTrioPhotoText } from "@w3yz/cms/api";

export const FashionTrioPhotoText = ({
  block,
}: {
  block: TinaGraphql_PageBlocksFashionTrioPhotoText;
}) => {
  return (
    <section data-tina-field={tinaField(block)} className="container flex">
      <div className="flex flex-col font-extrabold">
        <div className="mb-5 text-[#525252]"> {block.title}</div>
        <div className="clamp(1rem, 2.5vw, 2rem) mb-3 md:text-[2.5rem] ">
          {block.subTitle}
        </div>

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
                    className="mb-6 h-[200px] object-cover lg:h-[404px]"
                  />
                  <h5 className="mb-2 text-2xl font-extrabold">
                    {item.image?.title}
                  </h5>
                  <h6 className="font-light">{item.image?.subtitle}</h6>
                </div>
              )
          )}
        </div>
      </div>
    </section>
  );
};
