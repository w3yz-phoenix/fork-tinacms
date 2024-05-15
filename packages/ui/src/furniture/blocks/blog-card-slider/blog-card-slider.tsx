import Image from "next/image";
import Link from "next/link";

import { tinaField } from "#ui/core/hooks";
import { ReactSlickSlider, type ReactSlick } from "#ui/core/lib/slick";
import "#ui/furniture/blocks/comment-slider/style.css";

import type { TinaGraphql_PageBlocksBlogCardSlider } from "@w3yz/cms/api";

export const BlogCardSlider = ({
  block,
}: {
  block: TinaGraphql_PageBlocksBlogCardSlider;
}) => {
  const settings: ReactSlick.Settings = {
    dots: true,
    infinite: true,
    slidesToShow: 3,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 5000,
    pauseOnHover: false,
    responsive: [
      {
        breakpoint: 750,
        settings: {
          slidesToShow: 2,
        },
      },
    ],
  };
  return (
    <section data-tina-field={tinaField(block)} className="w-full px-4">
      <label className="text-[32px] font-normal leading-[48px] text-zinc-800">
        {block.Title}
      </label>
      <div className=" w-full">
        <ReactSlickSlider {...(settings as any)}>
          {block?.blogCardSlider?.map((item, index) => (
            <div key={index} className="mx-auto max-w-[316px]">
              <div className="flex flex-col gap-4">
                <div className="relative h-[250px] w-[316px]">
                  <Image
                    src={item?.image?.src || ""}
                    alt={item?.image?.alt || ""}
                    width={316}
                    height={250}
                    className="object-cover"
                  />
                  <span className="absolute left-0 top-0 inline-flex h-10 items-center justify-center gap-2.5 bg-rose-400 p-2.5 text-white">
                    {item?.date
                      ? new Date(item.date).toLocaleDateString("en-GB")
                      : ""}
                  </span>
                </div>
                <div className="flex flex-col gap-3">
                  <p className="text-base font-normal leading-normal tracking-tight text-stone-500">
                    {item?.description}
                  </p>
                  <Link
                    className="inline-flex h-11 max-w-fit shrink items-center justify-center gap-3 rounded border border-stone-300 bg-white px-7 py-4 shadow"
                    href={item?.link || ""}
                  >
                    Devamı
                  </Link>
                </div>
              </div>
            </div>
          ))}
        </ReactSlickSlider>
      </div>
    </section>
  );
};
