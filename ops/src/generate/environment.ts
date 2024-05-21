import * as path from "https://deno.land/std@0.224.0/path/mod.ts";
import { Command } from "https://deno.land/x/cliffy@v1.0.0-rc.4/command/mod.ts";
import { PROJECT_ROOT, getGithubAuthToken, getMongodbPort } from "../utils.ts";

const targetOptions = ["development", "staging", "production"];

export const environment = new Command()
  .name("environment")
  .description("Generate environment variable files")
  .complete("target", () => targetOptions)
  .option(
    "-t, --target <target:string:target>",
    "Target environment for the environment variables",
    {
      default: "development",
    }
  )
  .option(
    "--require-github-token <value?:boolean>",
    "Whether to require a GitHub token to be set"
  )
  .option(
    "--require-kubectl <value?:boolean>",
    "Whether to require a GitHub token to be set"
  )
  .action(async (options) => {
    console.log("Generating environment variables for target:", options.target);

    const params = {
      target: options.target,
      requireGithubToken:
        options.requireGithubToken ?? options.target !== "development",
      requireKubectl:
        options.requireKubectl ?? options.target !== "development",
    };

    const generateBaseEnvironment = async () => {
      const GITHUB_TOKEN = await getGithubAuthToken(params.requireGithubToken);
      const SHOP_NAME = Deno.env.get("SHOP_NAME") ?? "demo";
      const ROOT_DOMAIN = Deno.env.get("ROOT_DOMAIN") ?? "beta.w3yz.dev";
      const SHOP_DOMAIN = `${SHOP_NAME}.${ROOT_DOMAIN}`;
      const NAMESPACE = `w3yz-shop-${SHOP_NAME}`;
      console.log("Domain:", SHOP_DOMAIN);

      const MONGODB_PORT = await getMongodbPort(
        NAMESPACE,
        params.requireKubectl
      );

      const NODE_ENV = "development";
      const TINA_PUBLIC_IS_LOCAL = "true";
      const NEXT_PUBLIC_TINA_IS_LOCAL = "true";
      const NEXT_PUBLIC_URL = `https://${SHOP_NAME}.${ROOT_DOMAIN}`;

      const NEXT_PUBLIC_ECOM_API_URL = `https://api.${SHOP_NAME}.${ROOT_DOMAIN}/graphql/`;
      const NEXT_PUBLIC_ECOM_NAME = `${SHOP_NAME}`;
      const NEXT_PUBLIC_SHOP_DOMAIN = `${SHOP_DOMAIN}`;
      const NEXT_PUBLIC_CMS_BASE_URL = `https://${SHOP_NAME}.${ROOT_DOMAIN}`;
      const NEXTAUTH_SECRET = `change-me`;
      const MONGODB_URI = `mongodb://${SHOP_DOMAIN}:${MONGODB_PORT}/${SHOP_NAME}`;

      const GITHUB_OWNER = "w3yz-phoenix";
      const GITHUB_REPO = "live";
      const GITHUB_BRANCH = "main";
      const GITHUB_PERSONAL_ACCESS_TOKEN = GITHUB_TOKEN;

      const NEXT_PUBLIC_MONGO_PORT = MONGODB_PORT;
      const NEXT_PUBLIC_SHOP_NAME = SHOP_NAME;
      const NEXT_PUBLIC_ROOT_DOMAIN = ROOT_DOMAIN;
      const MY_PERSONAL_GITHUB_TOKEN = GITHUB_TOKEN;

      return {
        SHOP_NAME,
        ROOT_DOMAIN,

        NEXT_PUBLIC_SHOP_NAME,
        NEXT_PUBLIC_ROOT_DOMAIN,

        SHOP_DOMAIN,
        NAMESPACE,
        MY_PERSONAL_GITHUB_TOKEN,
        NEXT_PUBLIC_MONGO_PORT,
        NODE_ENV,
        NEXT_PUBLIC_URL,
        NEXT_PUBLIC_ECOM_API_URL,
        NEXT_PUBLIC_ECOM_NAME,
        NEXT_PUBLIC_SHOP_DOMAIN,
        NEXT_PUBLIC_CMS_BASE_URL,
        NEXTAUTH_SECRET,
        MONGODB_URI,
        GITHUB_OWNER,
        GITHUB_REPO,
        GITHUB_BRANCH,
        GITHUB_PERSONAL_ACCESS_TOKEN,
        TINA_PUBLIC_IS_LOCAL,
        NEXT_PUBLIC_TINA_IS_LOCAL,
      };
    };

    const generateDevelopmentEnvironment = async () => {
      const baseEnvironment = await generateBaseEnvironment();

      return {
        env: {
          ...baseEnvironment,
          NODE_ENV: "development",
          NEXT_PUBLIC_URL: "http://localhost:3000",
          NEXT_PUBLIC_CMS_BASE_URL: "http://localhost:3000",
          TINA_PUBLIC_IS_LOCAL: "true",
          NEXT_PUBLIC_TINA_IS_LOCAL: "true",
        },
        fileName: ".env.development.local",
      };
    };

    const generateStagingEnvironment = async () => {
      const baseEnvironment = await generateBaseEnvironment();

      return {
        env: {
          ...baseEnvironment,
          NODE_ENV: "production",
          TINA_PUBLIC_IS_LOCAL: "false",
          NEXT_PUBLIC_TINA_IS_LOCAL: "false",
        },
        fileName: ".env.staging.local",
      };
    };

    const generateProductionEnvironment = async () => {
      const baseEnvironment = await generateBaseEnvironment();

      return {
        env: {
          ...baseEnvironment,
          NODE_ENV: "production",
          TINA_PUBLIC_IS_LOCAL: "false",
          NEXT_PUBLIC_TINA_IS_LOCAL: "false",
        },
        fileName: ".env.production.local",
      };
    };

    const getEnvironment = () => {
      switch (options.target) {
        case "development":
          return generateDevelopmentEnvironment();
        case "staging":
          return generateStagingEnvironment();
        case "production":
          return generateProductionEnvironment();
        default:
          throw new Error("Invalid target environment");
      }
    };

    const environment = await getEnvironment();

    const envFileContent = Object.entries(environment.env)
      .map(([key, value]) => `${key}="${value}"`)
      .join("\n");

    await Deno.writeTextFile(
      path.resolve(PROJECT_ROOT, environment.fileName),
      envFileContent
    );
  });
