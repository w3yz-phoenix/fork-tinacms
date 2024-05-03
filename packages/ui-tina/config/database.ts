import { createDatabase, createLocalDatabase } from "@tinacms/datalayer";
import { GitHubProvider } from "tinacms-gitprovider-github";

// Manage this flag in your CI/CD pipeline and make sure it is set to false in production
const isLocal = process.env.TINA_PUBLIC_IS_LOCAL === "true";

const token = process.env.GITHUB_PERSONAL_ACCESS_TOKEN ?? "";
const owner = process.env.GITHUB_OWNER ?? "";
const repo = process.env.GITHUB_REPO ?? "";
const branch = process.env.GITHUB_BRANCH ?? "main";

if (!branch) {
  throw new Error(
    "No branch found. Make sure that you have set the GITHUB_BRANCH or process.env.VERCEL_GIT_COMMIT_REF environment variable."
  );
}

export const databaseClient = isLocal
  ? createLocalDatabase()
  : createDatabase({
      gitProvider: new GitHubProvider({
        branch,
        owner,
        repo,
        token,
      }),
      namespace: branch,
    });
