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
  return defineGraphqlProject("@w3yz/cms-tina", {
    schema: [resolvePath("../../tina/__generated__/schema.gql")],
    documents: [
      resolvePath("../../tina/__generated__/frags.gql"),
      resolvePath("../../tina/__generated__/queries.gql"),
    ],
    extensions: {
      codegen: defineCodegenConfig({
        config,
        generates: {
          [resolvePath("../generated/tinacms.gen.ts")]: {
            plugins: [
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
