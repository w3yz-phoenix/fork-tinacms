"use client";

import {
  tinaField,
  usePageQuery,
  useTinaQuery,
  type TinaGraphql_PageQuery,
} from "@w3yz/cms-tina";
import { TinaMarkdown } from "tinacms/dist/rich-text";

export const PageClient = (props: { relativePath: string }) => {
  const { page } = useTinaQuery<TinaGraphql_PageQuery>(usePageQuery, {
    relativePath: props.relativePath,
  });

  const bodyAsArray = page?.body as any;

  return (
    <div>
      <div>
        <h1>Reference Header</h1>
      </div>
      <h1>
        Welcome to
        <span data-tina-field={tinaField(page, "title")}>{page?.title}</span>
      </h1>
      <div data-tina-field={tinaField(page, "body")}>
        {bodyAsArray && <TinaMarkdown content={bodyAsArray} />}
      </div>
    </div>
  );
};
