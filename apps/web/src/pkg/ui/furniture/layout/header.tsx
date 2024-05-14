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

import { CartIndicator } from "./cart-indicator";

const ImageComponent = ({
  image,
  "data-tina-field": dataTinaField,
}: {
  image?: Maybe<Get<TinaGraphql_GlobalConfigQuery, "globalConfig.header.logo">>;
  "data-tina-field"?: string;
}) => {
  const imageElement = (
    <Image
      src={image?.src ?? "/bultin/placeholder.png"}
      width={189}
      height={29}
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

type HeaderProps = {
  globalConfigPath: string;
  cartItemCount: number;
};

export const Header = ({ globalConfigPath, cartItemCount }: HeaderProps) => {
  const { globalConfig } = useTinaQuery<TinaGraphql_GlobalConfigQuery>(
    useGlobalConfigQuery,
    {
      relativePath: globalConfigPath,
    }
  );

  const header = globalConfig?.header;

  return (
    <div
      className="flex w-full flex-col"
      data-tina-field={tinaField(globalConfig, "header")}
    >
      <div className="w-full flex-col lg:flex">
        <div className="flex items-center justify-between bg-white px-[60px] py-8">
          <ImageComponent
            data-tina-field={tinaField(header as any, "logo")}
            image={header?.logo}
          />
          <div className="flex items-center gap-x-6 text-base font-normal text-[#292929] lg:gap-x-12 2xl:gap-x-[90px] 2xl:text-xl">
            {header?.links?.map((link, index) => {
              switch (link?.__typename) {
                case "GlobalConfigHeaderLinksLink": {
                  const href = `/${link?.page?._sys?.breadcrumbs?.join("/") ?? ""}`;
                  return (
                    <Link
                      key={`${link?.label}-${index}`}
                      href={href}
                      data-tina-field={tinaField(header, "links", index)}
                    >
                      {link?.label ?? ""}
                    </Link>
                  );
                }

                case "GlobalConfigHeaderLinksShoppingCart": {
                  return (
                    <CartIndicator
                      key={`cart-${index}`}
                      data-tina-field={tinaField(header, "links", index)}
                      block={link}
                      cartItemCount={cartItemCount}
                    />
                  );
                }

                default: {
                  return null;
                }
              }
            })}
          </div>
        </div>
      </div>
    </div>
  );
};
