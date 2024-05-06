import { type CodegenConfig } from "@graphql-codegen/cli";

import type { IGraphQLProject, IGraphQLConfig } from "graphql-config";

type ExtendObject<T> = Partial<T> & { [key: string]: any };

export const defineGraphqlConfig = <const T = ExtendObject<IGraphQLConfig>>(
  config: T
) => {
  return config;
};

export const defineGraphqlProject = <const T = ExtendObject<IGraphQLProject>>(
  name: string,
  config: T
) => {
  return {
    [name]: {
      ...config,
    },
  };
};

export const defineCodegenConfig = (
  config: Partial<CodegenConfig>
): CodegenConfig => {
  return {
    overwrite: true,
    ...config,
    config: {
      ...defaultConfig,
      ...config.config,
    },
    generates: {
      ...config.generates,
    },
  } as const;
};

export const reactQueryConfig = {
  exposeDocument: true,
  exposeQueryKeys: true,
  exposeQueryRootKeys: true,
  exposeMutationKeys: true,
  exposeFetcher: true,
  addInfiniteQuery: true,
  addSuspenseQuery: true,
  reactQueryVersion: 5,
  experimentalFragmentVariables: true,
  legacyMode: false,
  useTypeImports: false,
} as const;

export const defineReactQueryPlugin = <
  const T extends ExtendObject<typeof reactQueryConfig>,
>(
  config: T
) => {
  return {
    "typescript-react-query": {
      ...reactQueryConfig,
      ...config,
    },
  };
};

const defaultScalars = {
  _Any: 'CustomScalars["AnyObject"]',
  Date: "string",
  DateTime: "string",
  Day: "number",
  Decimal: "number",
  GenericScalar: 'CustomScalars["JSONValue"]',
  JSON: 'CustomScalars["JSONValue"]',
  JSONString: "string",
  Metadata: "Record<string, string>",
  Minute: "number",
  PositiveDecimal: "number",
  Upload: 'CustomScalars["AnyObject"]',
  UUID: "string",
  WeightScalar: "number",
  ID: "string",
  String: "string",
  Boolean: "boolean",
  // Int: "number",
  Float: "number",
  Reference: 'CustomScalars["AnyObject"]',
} as const;

const defaultConfig = {
  useTypeImports: true,
  strictScalars: true,
  dedupeFragments: true,
  enumAsTypes: true,
  futureProofEnums: true,
  namingConvention: "change-case#pascalCase",
  transformUnderscore: true,
  enumPrefix: true,
  wrapFieldDefinitions: true,
  typesPrefix: "I",
  scalars: defaultScalars,
} as const;
