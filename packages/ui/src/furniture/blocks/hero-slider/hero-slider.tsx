import { tinaField } from "tinacms/dist/react";
import Image from "next/image";

import { ReactSlickSlider, type ReactSlick } from "@@ui/core/lib/slick";

import type { TinaGraphql_PageBlocksHeroSlider } from "@w3yz/cms/api";

export const HeroSliderBlock = ({
  block,
}: {
  block: TinaGraphql_PageBlocksHeroSlider;
}) => {
  const settings: ReactSlick.Settings = {
    className: "center",
    centerMode: true,
    infinite: true,
    centerPadding: "150px",
    dots: true,
    slidesToShow: 1,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 5000,
    pauseOnHover: false,
    responsive: [
      {
        breakpoint: 650,
        settings: {
          centerPadding: "50px",
        },
      },
    ],
  };

  return (
    <section className="mt-[144px]" data-tina-field={tinaField(block)}>
      <div className="container mx-auto mb-7 px-5 text-center lg:mb-16">
        <label className="text-[28px] font-semibold text-[#292929] md:text-[32px] lg:text-[67px]">
          {block.title}
        </label>
        <p className="text-[18px] text-[#525252] md:text-[22px] lg:text-[45px]">
          {block.subtitle}
        </p>
      </div>
      {block.images && block.images?.length > 0 && (
        <div className="relative">
          <ReactSlickSlider {...(settings as any)}>
            {block.images?.map(
              (item, index) =>
                item && (
                  <div
                    key={index}
                    className="relative flex w-full items-center px-1 outline-none"
                    data-tina-field={tinaField(item)}
                  >
                    <Image
                      src={item?.image ?? ""}
                      width={1920}
                      height={637}
                      alt={item?.alt ?? ""}
                      className="object-contain "
                    />
                  </div>
                )
            )}
          </ReactSlickSlider>
        </div>
      )}
    </section>
  );
};
