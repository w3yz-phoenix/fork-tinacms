"use client";

import { usePageQuery, type TinaGraphql_PageQuery } from "@w3yz/cms/api";

import { FeaturesBlock } from "@@ui/furniture/blocks/features/features";

import { useTinaQuery } from "../../hooks";

export const PageClient = (props: { relativePath: string }) => {
  const { page } = useTinaQuery<TinaGraphql_PageQuery>(usePageQuery, {
    relativePath: props.relativePath,
  });

  return (
    <div>
      {page?.blocks?.map((block, index) => {
        if (!block) return null;

        switch (block.__typename) {
          case "PageBlocksFeatures": {
            return <FeaturesBlock key={index} block={block} />;
          }
          default: {
            return null;
          }
        }
      })}
    </div>
  );
};
