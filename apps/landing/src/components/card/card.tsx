import Image from "next/image";

export interface CardProperties {
  size: "small" | "medium" | "large" | "horizontal";
  title: string;
  description: string;
  image: { path: string; alt: string };
}

export const Card = ({
  size,
  title,
  description,
  image: { path, alt },
}: CardProperties) => {
  switch (size) {
    case "small": {
      return (
        <div className="group/card flex max-h-[358px] max-w-[360px] flex-col rounded-lg border border-violet-100 bg-gradient-to-b from-violet-50 via-purple-50 to-white p-2 shadow  md:p-3 lg:p-6 4xl:h-[358px]">
          <div className="flex max-h-[110px] items-center justify-center sm:max-h-[150px] md:max-h-[169px] md:pt-[10px] lg:max-h-full lg:pt-[20px] xl:pb-2">
            <Image
              src={path}
              alt={alt}
              width={240}
              height={169}
              className="h-[169px] w-[240px] object-scale-down max-sm:max-w-[150px]"
            />
          </div>
          <div className="flex flex-col gap-1">
            <p className="w-full py-1 text-sm font-medium leading-normal text-[#363A44]  md:text-xl">
              {title}
            </p>
            <p className=" w-full py-1.5 text-sm font-normal leading-normal text-[#8A94A6]  md:text-xl">
              {description}
            </p>
          </div>
        </div>
      );

      break;
    }
    case "medium": {
      return (
        <div className="group/card flex max-h-[358px] max-w-[453px] flex-col rounded-lg border border-violet-100 bg-gradient-to-b from-violet-50 via-purple-50 to-white p-2 shadow  md:p-3 lg:p-6 3xl:h-[358px]">
          <div className="flex max-h-[110px] items-center justify-center sm:max-h-[150px] md:max-h-[169px] md:pt-[10px] lg:max-h-full lg:pt-[20px] xl:pb-8">
            <Image
              src={path}
              alt={alt}
              width={240}
              height={169}
              className="h-[169px] w-[240px] object-scale-down max-sm:max-w-[150px]"
            />
          </div>
          <div className="flex flex-col gap-1">
            <p className="w-full py-1 text-sm font-medium leading-normal text-[#363A44]  md:text-xl">
              {title}
            </p>
            <p className="w-full py-1.5 text-sm  font-normal leading-normal text-[#8A94A6]  md:text-xl">
              {description}
            </p>
          </div>
        </div>
      );

      break;
    }
    case "large": {
      return (
        <div className="group/card flex max-h-[486px] max-w-[638px] flex-col rounded-lg border border-violet-100 bg-gradient-to-b from-violet-50 via-purple-50 to-white p-2 shadow  md:p-3 lg:p-6 xl:w-[638px]">
          <div className="flex items-center justify-center lg:pt-[20px] xl:pb-8">
            <Image
              src={path}
              alt={alt}
              width={252}
              height={358}
              className="h-[252px] w-[358px] object-scale-down "
            />
          </div>
          <div className="flex flex-col gap-1">
            <p className=" w-full py-1 text-sm font-medium leading-normal text-[#363A44]  md:text-xl">
              {title}
            </p>
            <p className=" w-full py-1.5 text-sm font-normal leading-normal text-[#8A94A6]  md:text-xl 2xl:w-[300px]">
              {description}
            </p>
          </div>
        </div>
      );

      break;
    }
    case "horizontal": {
      return (
        <div className="group/card flex max-h-[112px] max-w-[735px] items-center justify-start gap-4 rounded-lg border border-violet-100 bg-gradient-to-b from-violet-50 via-purple-50 to-white p-6 shadow ">
          <div className="flex items-center justify-center">
            <Image
              src={path}
              alt={alt}
              width={221}
              height={89}
              className="h-[89px] w-[221px] object-scale-down"
            />
          </div>
          <div>
            <p className="flex w-full items-center text-sm font-medium leading-normal text-[#363A44]  md:text-xl">
              {title}
            </p>
            <p className=" w-full text-sm font-normal leading-normal text-[#8A94A6] md:text-xl">
              {description}
            </p>
          </div>
        </div>
      );

      break;
    }

    default: {
      break;
    }
  }
};
