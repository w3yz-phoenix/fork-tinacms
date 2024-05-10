"use client";

import { tinaField, useTinaQuery } from "#ui/core/hooks";
import {
  useCustomPageQuery,
  type TinaGraphql_CustomPageBodyFilter,
  type TinaGraphql_CustomPageQuery,
} from "@w3yz/cms/api";
import Image from "next/image";
import Link from "next/link";
import {
  TinaMarkdown,
  type Components,
  type TinaMarkdownContent,
} from "tinacms/dist/rich-text";

const baseComponents: Components<object> = {
  h1: (props) => {
    return <h1 className="text-4xl font-bold">{props?.children}</h1>;
  },
  h2: (props) => {
    return <h2 className="text-3xl font-bold">{props?.children}</h2>;
  },
  h3: (props) => {
    return <h3 className="text-2xl font-bold">{props?.children}</h3>;
  },
  h4: (props) => {
    return <h4 className="text-xl font-bold">{props?.children}</h4>;
  },
  h5: (props) => {
    return <h5 className="text-lg font-bold">{props?.children}</h5>;
  },
  h6: (props) => {
    return <h6 className="text-base font-bold">{props?.children}</h6>;
  },
  p: (props) => {
    return <p className="text-base">{props?.children}</p>;
  },
  a: (props) => {
    return <Link href={props?.url ?? "#"}>{props?.children}</Link>;
  },
  img: (props) => {
    return <Image src={props?.url ?? ""} alt={props?.alt ?? ""} />;
  },
  ul: (props) => {
    return <ul className="list-disc">{props?.children}</ul>;
  },
  ol: (props) => {
    return <ol className="list-decimal">{props?.children}</ol>;
  },
  li: (props) => {
    return <li>{props?.children}</li>;
  },
  block_quote: (props) => {
    return <blockquote>{props?.children}</blockquote>;
  },
  code: (props) => {
    return <code>{props?.children}</code>;
  },
};

const components: Components<TinaGraphql_CustomPageBodyFilter> = {
  ...baseComponents,
  RotatingText: (props) => {
    const text = (props?.children ?? "icerik giriniz") as string;
    return (
      <div className="flex w-full animate-spin items-center justify-center text-3xl text-fuchsia-600">
        {text}
      </div>
    );
  },
};

export const CustomPageClient = (props: { relativePath: string }) => {
  const { customPage } = useTinaQuery<TinaGraphql_CustomPageQuery>(
    useCustomPageQuery,
    {
      relativePath: props.relativePath,
    }
  );

  const pageBody = customPage.body as TinaMarkdownContent;

  return (
    <div data-tina-field={tinaField(customPage, "body")}>
      <TinaMarkdown components={components} content={pageBody} />
    </div>
  );
};
