import { tinaField } from "@@ui/core/hooks";

import type { TinaGraphql_PageBlocksDemoFeatures } from "@w3yz/cms/api";

export const DemoFeaturesBlock = ({
  block,
}: {
  block: TinaGraphql_PageBlocksDemoFeatures;
}) => {
  const { items } = block;
  return (
    <section className="container mx-auto mt-14 grid grid-cols-2 gap-6 px-5 md:grid-cols-4">
      {items?.map((item, index) => {
        if (!item) return null;
        return (
          <div
            data-tina-field={tinaField(item)}
            key={index}
            className="mx-auto flex flex-col items-center text-center md:max-w-[216px]"
          >
            {/* <Image src={image} width={60} height={55} alt="" /> */}
            <label className="mb-3 mt-4 text-[18px] font-bold text-[#292929] lg:text-[20px]">
              {item?.title}
            </label>
            <div className="mb-3 mt-4 text-[16px] font-bold text-[#292929] lg:text-[20px]">
              {item?.subtitle}
            </div>
            <p className="text-[14px] text-[#656565] lg:text-[16px]">
              {item?.text}
            </p>
          </div>
        );
      })}
    </section>
  );
};
