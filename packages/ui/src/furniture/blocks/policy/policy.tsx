"use client";

import { tinaField } from "tinacms/dist/react";
import { useEffect, useState } from "react";

import type { TinaGraphql_PageBlocksPolicy } from "@w3yz/cms/api";

export const PolicyBlock = ({
  block,
}: {
  block: TinaGraphql_PageBlocksPolicy;
}) => {
  const [activePolicy, setActivePolicy] = useState<string | undefined>();
  useEffect(() => {
    block?.policiesNames
      ?.slice(0, 1)
      .map((item) => setActivePolicy(item?.policyName));
  }, [block.policiesNames]);
  return (
    <div
      className="container mx-auto flex flex-col bg-[#FFF] py-[105px] max-lg:px-4"
      data-tina-field={tinaField(block)}
    >
      <h3 className="text-xl font-semibold text-[#00C48C]">
        {block.mainTitle}
      </h3>
      <h1 className="py-[16px] text-4xl font-semibold text-[#101828] ">
        {block.subTitle}
      </h1>
      <p className="max-w-[650px] text-2xl font-normal text-[#475467]">
        {block.description}
      </p>
      <div className="flex flex-col pt-[22px] md:pt-[40px] lg:flex-row">
        <div className="flex flex-col gap-2 pt-4 max-lg:justify-center md:flex-row">
          <div className="flex flex-row pt-4 md:flex-col">
            {block.policiesNames?.map((item, index) => (
              <div
                className="flex flex-col-reverse pt-4  lg:flex-row"
                key={index}
              >
                <div
                  className={`${
                    item?.policyName === activePolicy
                      ? "opacity-100"
                      : "opacity-0"
                  } ml-2 rounded-[199px] bg-[#00C48C] max-lg:mt-1 max-lg:h-1 max-lg:w-[93%] lg:h-9 lg:w-[3px]`}
                />
                <button
                  onClick={() => setActivePolicy(item?.policyName)}
                  className={`${
                    item?.policyName === activePolicy
                      ? "ml-2 rounded-lg   bg-[#EAFFF6] px-4  py-2 text-[14px] font-normal text-[#24262D]"
                      : "ml-2   bg-[#FFF]  px-4 py-2 text-[14px] font-normal text-[#565E73]"
                  }`}
                >
                  {item?.policyName}
                </button>
              </div>
            ))}
          </div>
          <div className="flex max-w-[800px] flex-col bg-[#FAFAFC] p-3 max-lg:pt-8 lg:p-6 xl:max-w-[1161px]">
            {block.policies?.map(
              (item, index) =>
                activePolicy === item?.policyTitle && (
                  <div className="flex flex-col pt-3" key={index}>
                    <h1 className="text-2xl font-medium text-[#101828]">
                      {item?.policyTitle}
                    </h1>
                    <p className="pt-3 text-xl font-normal text-[#475467]">
                      {item?.policyDescription}
                    </p>
                  </div>
                )
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
