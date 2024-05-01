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
  return defineGraphqlProject("@w3yz/ecom-saleor", {
    schema: [resolvePath("../vendor/*.graphql")],
    documents: [resolvePath("../graphql/**/*.graphql")],
    extensions: {
      codegen: defineCodegenConfig({
        config,
        generates: {
          [`${resolvePath("../generated/gql.gen.ts")}`]: {
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
