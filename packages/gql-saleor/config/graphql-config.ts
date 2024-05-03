import {
  defineCodegenConfig,
  defineGraphqlProject,
  defineReactQueryPlugin,
  templates,
} from "@w3yz/tool-graphql";
import path from "path";

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
  return defineGraphqlProject("@w3yz/gql-saleor", {
    schema: [resolvePath("../src/vendor/*.graphql")],
    documents: [resolvePath("../src/graphql/**/*.graphql")],
    extensions: {
      codegen: defineCodegenConfig({
        config,
        generates: {
          [`${resolvePath("../src/__generated__/gql.ts")}`]: {
            plugins: [
              {
                add: {
                  content: "// @ts-nocheck",
                },
              },
              templates.eslintDisable,
              templates.customScalars,
              "typescript",
              {
                "typescript-operations": {
                  skipTypeNameForRoot: true,
                  exportFragmentSpreadSubTypes: true,
                  onlyOperationTypes: true,
                },
              },
              defineReactQueryPlugin({
                fetcher: "../fetcher#fetcher",
              }),
            ],
          },
        },
      }),
    },
  });
};
