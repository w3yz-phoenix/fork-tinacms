"use client";

import { useState } from "react";

import { PriceCard } from "#landing/components/price/price-card";
import { PriceFeatureProperties } from "#landing/components/price/price-feature";

// import { Toggle } from "../switch-button";

import { Commerce } from "./commerce";

const priceFeaturesBasic: PriceFeatureProperties[] = [
  { feature: "10 adet ürün yükleme", featureAvailable: true },
  { feature: "5 Gb Bandwidth", featureAvailable: true },
  { feature: "64 Mb Sunucu Bellek", featureAvailable: true },
  { feature: "Özel Domain Bağlama", featureAvailable: false },
  { feature: "Entegrasyon", featureAvailable: false },
];
const priceFeaturesPro: PriceFeatureProperties[] = [
  { feature: "Özel Domain Bağlama", featureAvailable: true },
  { feature: "30 Adet Ürün Yükleme", featureAvailable: true },
  { feature: "10 Gb Bandwidth", featureAvailable: true },
  { feature: "256 Mb Sunucu Bellek", featureAvailable: true },
  { feature: "Entegrasyonlar", featureAvailable: true },
];
const priceFeaturesCompany: PriceFeatureProperties[] = [
  { feature: "Özel Domain Bağlama", featureAvailable: true },
  { feature: "200 Adet Ürün Yükleme", featureAvailable: true },
  { feature: "Sınırsız Bandwidth", featureAvailable: true },
  { feature: "512 Mb Sunucu Bellek", featureAvailable: true },
  { feature: "Entegrasyonlar", featureAvailable: true },
];
const priceFeaturesSpecial: PriceFeatureProperties[] = [
  { feature: "Özel Domain Bağlama", featureAvailable: true },
  { feature: "500 Adet Ürün Yükleme", featureAvailable: true },
  { feature: "Sınırsız Bandwidth", featureAvailable: true },
  { feature: "1 Gb Sunucu Bellek", featureAvailable: true },
  { feature: "Özelleştirilmiş Çözümler", featureAvailable: true },
];

export const PriceCardSection = () => {
  const [isYearly, setIsYearly] = useState(false);
  console.log(setIsYearly);
  return (
    <div
      className="mb-8 flex flex-col items-center justify-center p-4"
      id="fiyatlar"
    >
      <div className="flex flex-col items-center justify-center gap-9">
        <div className="flex flex-col items-center justify-center gap-4">
          <p className="text-sm font-medium leading-none text-[#404040]">
            FİYATLAR
          </p>
          <h3 className="text-center text-[48px] font-medium leading-[80px] text-[#0A0A0A] md:text-[64px]">
            Planları keşfet
          </h3>
          <p className="text-center text-3xl font-normal leading-loose">
            Basit, şeffaf ve işiniz ile birlikte büyüyen fiyatlar.
          </p>
        </div>
        {/* <div className="flex items-center justify-center gap-[11px] text-[#525252]">
          <p>Aylık</p>
          <Toggle
            name="price"
            value="yearly"
            checked={isYearly}
            onChange={(isChecked) => setIsYearly(isChecked)}
          />
          <p>Yıllık</p>
          <p className="inline-flex h-[26px] w-[96px] items-center justify-center border border-[#EED8D8] bg-[#F6EAEA] px-[9px] py-[5px] text-sm font-medium leading-none text-[#761E1E]">
            Popüler
          </p>
        </div> */}
      </div>

      <div className="flex flex-col items-center justify-center gap-[145px]">
        <div className="grid grid-cols-1 justify-items-center gap-y-14 md:grid-cols-2 2xl:grid-cols-4">
          <PriceCard
            priceFeatures={priceFeaturesBasic}
            plan="Başlangıç"
            planType="Basic"
            monthlyPrice="0"
            yearlyPrice="0"
            link={"#"}
            isYearly={isYearly}
          />
          <PriceCard
            priceFeatures={priceFeaturesPro}
            planType="Pro"
            monthlyPrice="150"
            yearlyPrice="1500"
            link={"#"}
            isYearly={isYearly}
          />
          <PriceCard
            priceFeatures={priceFeaturesCompany}
            plan="Popüler"
            planType="Company"
            monthlyPrice="750"
            yearlyPrice="7500"
            link={"#"}
            isYearly={isYearly}
          />
          <PriceCard
            priceFeatures={priceFeaturesSpecial}
            planType="Special"
            monthlyPrice="2850"
            yearlyPrice="28500"
            link={"#"}
            isYearly={isYearly}
          />
        </div>
        <div>
          <Commerce />
        </div>
      </div>
    </div>
  );
};
