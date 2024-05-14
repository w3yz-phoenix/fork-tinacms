import Link from "next/link";

import { cn } from "#landing/app/lib/utils";

import { ButtonGreen } from "../button";

import { PriceFeature } from "./price-feature";

interface PriceCardProperties {
  plan?: "Başlangıç" | "Popüler";
  planType: string;
  monthlyPrice?: number | string;
  yearlyPrice?: number | string;
  priceFeatures: { feature: string; featureAvailable: boolean }[];
  link: string;
  isYearly?: boolean;
}

export const PriceCard = ({
  plan,
  planType,
  monthlyPrice,
  yearlyPrice,
  isYearly,
  priceFeatures,
  link,
}: PriceCardProperties) => {
  return (
    <div className=" h-[503px] w-[381px] rounded p-8 max-sm:border max-sm:border-DEFAULT">
      <div className="flex h-full flex-col items-start justify-center gap-6 ">
        <div className="flex w-full justify-between">
          <div className="flex flex-col items-start gap-[7px]">
            <p className="inline-flex h-4 items-center justify-center text-sm font-medium leading-none text-[#737373]">
              PLAN
            </p>
            <p className="text-4xl font-medium leading-loose text-[#171717]">
              {planType}
            </p>
          </div>
          <div>
            <p
              className={cn(
                plan && "border  px-[9px] py-[5px] text-sm leading-none ",
                plan === "Başlangıç" &&
                  "border-[#E8EEF7] bg-[#F3F6FC] text-[#27497C]",
                plan === "Popüler" &&
                  "bg-[#F6EAEA] border-[#EED8D8] text-[#761E1E]"
              )}
            >
              {plan}
            </p>
          </div>
        </div>

        <div>
          <div className="flex h-20 items-center justify-start ">
            <p className="text-[64px] font-normal leading-[80px] text-[#0A0A0A]">
              ₺{isYearly ? yearlyPrice : monthlyPrice}
            </p>
            <div className="flex items-center justify-end  ">
              <p className="h-10 text-xl font-normal text-[#404040]">
                <br />
                {isYearly ? "/yıllık" : "/aylık"}
              </p>
            </div>
          </div>
        </div>
        <div className="flex flex-col items-start gap-4">
          {priceFeatures.map((item, index) => (
            <PriceFeature
              key={index}
              feature={item.feature}
              featureAvailable={item.featureAvailable}
            />
          ))}
        </div>
        <div className="flex flex-col items-center justify-center gap-2">
          <Link href={link}>
            <ButtonGreen name="Planı Seç" />
          </Link>
        </div>
      </div>
    </div>
  );
};
