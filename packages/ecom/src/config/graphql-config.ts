/* eslint-disable unicorn/prefer-module */
import path from "node:path";

import { graphqlConfigTools, graphqlTemplates } from "@w3yz/tools/graphql";

export const resolvePath = (relativePath: string) => {
  return path.resolve(__dirname, relativePath);
};

const typePrefix = "SaleorGraphql_";
const config = {
  typesPrefix: typePrefix,
  documentPrefix: typePrefix,
  fragmentPrefix: typePrefix,
  documentVariablePrefix: typePrefix,
  fragmentVariablePrefix: typePrefix,
};

export const getSaleorGraphqlConfig = () => {
  return graphqlConfigTools.defineGraphqlProject("@w3yz/ecom", {
    schema: [resolvePath("../vendor/*.graphql")],
    documents: [resolvePath("../graphql/**/*.graphql")],
    extensions: {
      codegen: graphqlConfigTools.defineCodegenConfig({
        config,
        generates: {
          [`${resolvePath("../__generated__/gql.ts")}`]: {
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
              {
                "typescript-validation-schema": {
                  schema: "zod",
                },
              },
              graphqlConfigTools.defineReactQueryPlugin({
                fetcher: "@w3yz/ecom/fetcher#fetcher",
              }),
            ],
          },
        },
      }),
    },
  });
};
