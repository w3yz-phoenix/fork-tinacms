import path from "node:path";

import { graphqlConfigTools, graphqlTemplates } from "@w3yz/tools/graphql";

const { defineCodegenConfig, defineGraphqlProject, defineReactQueryPlugin } =
  graphqlConfigTools;

export const resolvePath = (relativePath: string) => {
  // eslint-disable-next-line unicorn/prefer-module
  return path.resolve(__dirname, relativePath);
};

const typePrefix = "TinaGraphql_";
const config = {
  typesPrefix: typePrefix,
  documentPrefix: typePrefix,
  fragmentPrefix: typePrefix,
  documentVariablePrefix: typePrefix,
  fragmentVariablePrefix: typePrefix,
};

export const getTinaGraphqlConfig = () => {
  return defineGraphqlProject("@w3yz/cms", {
    schema: [resolvePath("../../tina/__generated__/schema.gql")],
    documents: [
      resolvePath("../../tina/__generated__/frags.gql"),
      resolvePath("../../tina/__generated__/queries.gql"),
    ],
    extensions: {
      codegen: defineCodegenConfig({
        config,
        generates: {
          [resolvePath("../__generated__/gql.ts")]: {
            plugins: [
              {
                add: {
                  content: "// @ts-nocheck",
                },
              },
              graphqlTemplates.eslintDisable,
              graphqlTemplates.customScalars,
              "typescript",
              {
                "typescript-operations": {
                  skipTypeNameForRoot: true,
                  exportFragmentSpreadSubTypes: true,
                  onlyOperationTypes: true,
                },
              },
              defineReactQueryPlugin({
                fetcher: "@w3yz/cms/fetcher#fetcher",
              }),
            ],
          },
        },
      }),
    },
  });
};
