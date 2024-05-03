"use client";

import {
  useGlobalConfigQuery,
  type Maybe,
  type TinaGraphql_GlobalConfigQuery,
} from "@w3yz/gql-tina";
import Image from "next/image";
import Link from "next/link";

import type { Get } from "type-fest";

import { tinaField, useTinaQuery } from "../../hooks";

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
  const content = image?.link ? (
    <Link href={image?.link._sys.filename}>{imageElement}</Link>
  ) : (
    imageElement
  );
  return <div data-tina-field={dataTinaField}>{content}</div>;
};

export const Header = ({ globalConfigPath }: { globalConfigPath: string }) => {
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
      <div className="hidden w-full flex-col lg:flex">
        <div className="flex items-center justify-between bg-white px-[60px] py-8">
          <ImageComponent
            data-tina-field={tinaField(header as any, "logo")}
            image={header?.logo}
          />
          <div className="flex items-center gap-x-6 text-base font-normal text-[#292929] lg:gap-x-12 2xl:gap-x-[90px] 2xl:text-xl">
            {header?.links?.map((link, index) => (
              <Link
                key={link?.label}
                href={`/${link?.page?._sys?.filename ?? ""}`}
                data-tina-field={tinaField(header, "links", index)}
              >
                {link?.label ?? ""}
              </Link>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};
