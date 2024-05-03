/* eslint-disable no-undef */
/* eslint-disable unicorn/prefer-module */
const typescriptProject = [
  "./tsconfig.json",
  "./packages/*/tsconfig.json",
  "./apps/*/tsconfig.json",
];

const config = {
  env: {
    node: true,
  },
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: typescriptProject,
  },
  settings: {
    "import/resolver": {
      typescript: {
        project: typescriptProject,
      },
      node: {
        project: typescriptProject,
      },
    },
  },
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:unicorn/recommended",
    "plugin:import/recommended",
    "plugin:import/typescript",
    "plugin:prettier/recommended",
    "plugin:tailwindcss/recommended",
  ],
  rules: {
    "import/order": [
      "error",
      {
        "newlines-between": "always",
        distinctGroup: false,
        pathGroups: [
          {
            pattern: "@/**",
            group: "internal",
            position: "before",
          },
        ],
        groups: [
          "builtin",
          "external",
          "internal",
          "index",
          "type",
          "object",
          "parent",
          "sibling",
        ],
      },
    ],
    "@typescript-eslint/no-explicit-any": "off",
    // allow unused vars prefixed with `_`
    "@typescript-eslint/no-unused-vars": [
      "error",
      { argsIgnorePattern: "^_", varsIgnorePattern: "^_" },
    ],
    "unicorn/no-null": "off",
    "unicorn/filename-case": [
      "error",
      {
        case: "kebabCase",
        ignore: [],
      },
    ],
    "unicorn/prevent-abbreviations": [
      "error",
      {
        allowList: {
          getInitialProps: true,
          props: true,
          generateStaticParams: true,
          env: true,
          req: true,
          res: true,
          ref: true,
        },
      },
    ],
    "unicorn/no-array-callback-reference": "off",
    "unicorn/no-await-expression-member": "off",

    // array-callback-return is recommended
    // See https://github.com/sindresorhus/eslint-plugin-unicorn/blob/v48.0.1/docs/rules/no-useless-undefined.md
    "unicorn/no-useless-undefined": ["error", { checkArguments: false }],
    "array-callback-return": [
      "error",
      {
        allowImplicit: true,
      },
    ],
    "unicorn/no-array-reduce": ["error", { allowSimpleOperations: true }],
    "import/no-relative-packages": "error",
  },
  overrides: [
    {
      files: ["__tests__/**/*.{ts,tsx}"],
      extends: ["plugin:playwright/recommended"],
    },
    {
      files: ["**/*.{ts,tsx}"],
      excludedFiles: [
        "**/vite.config.ts",
        "**/custom/portal/**/*.{ts,tsx}",
        "**/*.stories.tsx",
        "**/app/**/page.tsx",
        "**/app/**/layout.tsx",
        "**/app/**/not-found.tsx",
        "**/app/**/loading.tsx",
        "**/app/**/default.{ts,tsx}",
        "**/app/**/error.tsx",
        "**/app/**/robots.ts",
        "**/src/pages/**",
      ],
      rules: {
        "import/no-default-export": "error",
      },
    },
  ],
  ignorePatterns: [
    "**/node_modules/**",
    "**/dist/**",
    "**/build/**",
    "**/out/**",
    "**/coverage/**",
    "**/public/**",
    "**/scripts/**",
    "**/tmp/**",
    "**/.next/**",
    "**/next.config.mjs",
    "**/postcss.config.cjs",
    "**/tailwind.config.ts",
    "**/.graphqlrc.ts",
    "**/gql/**",
    "**/generated/**",
    "**/__generated__/**",
    "**/*.snap",
    "**/*.svg",
    "**/*.tsbuildinfo",
    "**/*.woff",
    "**/*.woff2",
    "**/*.yml",
    "**/*.png",
    "**/vite-env.d.ts",
    "**/vite.config.ts",
    "**/src/schemas/**",
    "**/tina/**",
  ],
};

module.exports = config;
