import { tinaField } from "tinacms/dist/react";
import Image from "next/image";
import { IconArrowLeft, IconArrowRight } from "@tabler/icons-react";
import { Avatar, AvatarImage } from "#shadcn/components/avatar";
import "#ui/furniture/blocks/comment-slider/style.css";

import { ReactSlickSlider, type ReactSlick } from "#ui/core/lib/slick";

import type { TinaGraphql_PageBlocksCommentSlider } from "@w3yz/cms/api";

function SampleNextArrow(props: any) {
  const { className, onClick } = props;
  return (
    <div className={className} onClick={onClick}>
      <IconArrowRight size={20} />
    </div>
  );
}

function SamplePreviousArrow(props: any) {
  const { className, onClick } = props;
  return (
    <div className={className} onClick={onClick}>
      <IconArrowLeft size={20} />
    </div>
  );
}

export const CommentSliderBlock = ({
  block,
}: {
  block: TinaGraphql_PageBlocksCommentSlider;
}) => {
  const settings: ReactSlick.Settings = {
    dots: false,
    infinite: true,
    slidesToShow: 1,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 5000,
    pauseOnHover: false,
    nextArrow: <SampleNextArrow />,
    prevArrow: <SamplePreviousArrow />,
    responsive: [
      {
        breakpoint: 1200,
        settings: {
          dots: true,
        },
      },
    ],
  };

  return (
    <div data-tina-field={tinaField(block)} className="w-full">
      <div className="mb-20 flex flex-col items-center justify-center gap-4">
        <h3 className="text-center text-base font-normal text-emerald-500">
          {block.title}
        </h3>
        <h1 className="text-center text-[50px] font-bold leading-[62.50px] text-zinc-800">
          {block.titleDescription}
        </h1>
      </div>
      <div className="relative w-full">
        <ReactSlickSlider {...(settings as any)}>
          {block?.commentSlider?.map((item, index) => (
            <div key={index} className="px-4">
              <div>
                <div className="mb-10 flex flex-col items-center justify-center gap-4">
                  <div>
                    <Avatar className="size-24">
                      <AvatarImage src={item?.src} />
                    </Avatar>
                  </div>
                  <div className="flex flex-col items-center justify-center gap-2">
                    <h4 className="text-center text-base font-bold leading-tight tracking-tight text-zinc-800">
                      {item?.avatarTitle}
                    </h4>
                    <p className="text-center text-xs font-medium leading-[15px] tracking-tight text-stone-500">
                      {item?.avatarDescription}
                    </p>
                  </div>
                </div>
                <div className="flex flex-col items-center justify-center gap-8">
                  <h2 className="text-center text-[32px] font-bold leading-10 tracking-wide text-zinc-800">
                    {item?.subtitle}
                  </h2>
                  <p className="text-center text-xl font-normal leading-[30px] tracking-tight text-stone-500">
                    {item?.subtitleDescription}
                  </p>
                </div>
              </div>
            </div>
          ))}
        </ReactSlickSlider>
      </div>
    </div>
  );
};
