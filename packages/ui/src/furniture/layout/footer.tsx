"use client";

import Image from "next/image";
import Link from "next/link";
import {
  useGlobalConfigQuery,
  type Maybe,
  type TinaGraphql_GlobalConfigQuery,
} from "@w3yz/cms/api";

import { tinaField, useTinaQuery } from "#ui/core/hooks";

import type { Get } from "type-fest";

const ImageComponent = ({
  image,
  "data-tina-field": dataTinaField,
}: {
  image?: Maybe<Get<TinaGraphql_GlobalConfigQuery, "globalConfig.footer.logo">>;
  "data-tina-field"?: string;
}) => {
  const imageElement = (
    <Image
      src={image?.src ?? "/bultin/placeholder.png"}
      width={190}
      height={30}
      alt={image?.alt ?? "W3YZ"}
    />
  );
  const href = `/${image?.link?._sys?.breadcrumbs?.join("/") ?? ""}`;
  const content = image?.link ? (
    <Link href={href}>{imageElement}</Link>
  ) : (
    imageElement
  );
  return <div data-tina-field={dataTinaField}>{content}</div>;
};

type FooterProps = {
  globalConfigPath: string;
};

export const Footer = ({ globalConfigPath }: FooterProps) => {
  const { globalConfig } = useTinaQuery<TinaGraphql_GlobalConfigQuery>(
    useGlobalConfigQuery,
    {
      relativePath: globalConfigPath,
    }
  );

  const footer = globalConfig?.footer;

  return (
    <div
      data-tina-field={tinaField(globalConfig, "footer")}
      className="flex w-full justify-center  bg-black px-6 "
    >
      <div className="flex w-[1400px] flex-col">
        <div className="flex py-[52px] max-lg:flex-col max-lg:items-center lg:justify-between">
          <div className="flex flex-col">
            <ImageComponent
              data-tina-field={tinaField(footer as any, "logo")}
              image={footer?.logo}
            />
          </div>
          <div className="grid grid-cols-2 pl-0 text-[12px] font-normal text-white max-lg:w-full md:grid-cols-2 lg:grid-cols-4 lg:pl-7 2xl:pl-0"></div>
          {footer?.linksName?.map((link, index) => {
            return (
              <div
                key={index}
                className="mt-10 flex flex-col items-center text-center md:mt-0"
              >
                <label className="max-w-[150px] truncate text-[16px] font-semibold text-white">
                  {link?.title}
                </label>
                <div className="flex flex-col gap-y-2 pt-3">
                  {link?.links?.map((item, index) => {
                    return (
                      <Link
                        key={index}
                        href={`/${item?.page?._sys?.breadcrumbs?.join("/")}`}
                        className="max-w-[180px] truncate text-[14px] text-white"
                      >
                        {item?.label}
                      </Link>
                    );
                  })}
                </div>
              </div>
            );
          })}
        </div>
        <div className="flex justify-center py-[52px]">
          <Image
            src={footer?.odemelogo?.src ?? "/bultin/placeholder.png"}
            width={397}
            height={34}
            alt={footer?.odemelogo?.alt ?? "Odemelogo"}
          />
        </div>
      </div>
    </div>
  );
};
