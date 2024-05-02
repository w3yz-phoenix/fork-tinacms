"use client";

import { tinaField } from "tinacms/dist/react";
import {
  usePageQuery,
  useTinaQuery,
  type TinaGraphql_PageQuery,
} from "@w3yz/cms-tina";

export const PageClient = (props: { relativePath: string }) => {
  const pageProperties = useTinaQuery<TinaGraphql_PageQuery>(usePageQuery, {
    relativePath: props.relativePath,
  });

  return (
    <div>
      <h1>
        Welcome to
        <span data-tina-field={tinaField(pageProperties.page, "title")}>
          {pageProperties.page?.title}
        </span>
      </h1>
    </div>
  );
};
