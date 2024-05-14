import { IconFalse, IconOk } from "@/icons/price-section";

export interface PriceFeatureProperties {
  feature: string;
  featureAvailable: boolean;
}

export const PriceFeature = ({
  feature,
  featureAvailable,
}: PriceFeatureProperties) => {
  return (
    <div className="text-xl font-normal leading-normal text-[#404040]">
      {featureAvailable ? (
        <div className="flex items-center justify-center gap-3">
          <IconOk />
          <p>{feature}</p>
        </div>
      ) : (
        <div className="flex items-center justify-center gap-3 text-[#A3A3A3]">
          <IconFalse />
          <p>{feature}</p>
        </div>
      )}
    </div>
  );
};
