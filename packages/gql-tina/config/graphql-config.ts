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

const typePrefix = "TinaGraphql_";
const config = {
  typesPrefix: typePrefix,
  documentPrefix: typePrefix,
  fragmentPrefix: typePrefix,
  documentVariablePrefix: typePrefix,
  fragmentVariablePrefix: typePrefix,
};

export const getTinaGraphqlConfig = () => {
  return defineGraphqlProject("@w3yz/gql-tina", {
    schema: [
      resolvePath("../../../apps/storefront/tina/__generated__/schema.gql"),
    ],
    documents: [
      resolvePath("../../../apps/storefront/tina/__generated__/frags.gql"),
      resolvePath("../../../apps/storefront/tina/__generated__/queries.gql"),
    ],
    extensions: {
      codegen: defineCodegenConfig({
        config,
        generates: {
          [resolvePath("../src/generated/tinacms.gen.ts")]: {
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
