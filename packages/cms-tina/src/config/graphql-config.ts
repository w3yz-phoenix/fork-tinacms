import {
  defineCodegenConfig,
  defineGraphqlProject,
  defineReactQueryPlugin,
  templates,
} from "@w3yz/tool-graphql";
import { fileURLToPath } from "bun";

export const resolvePath = (path: string) => {
  return fileURLToPath(import.meta.resolve(path));
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
