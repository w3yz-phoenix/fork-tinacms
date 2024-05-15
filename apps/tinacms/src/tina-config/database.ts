import { createDatabase, createLocalDatabase } from "@tinacms/datalayer";
import { MongodbLevel } from "mongodb-level";
import { GitHubProvider } from "tinacms-gitprovider-github";
import { tinaEnvironment } from "../lib/environment";

const branch =
  process.env.GITHUB_BRANCH ||
  process.env.VERCEL_GIT_COMMIT_REF ||
  process.env.HEAD ||
  "main";

export const tinaDatabase = tinaEnvironment.public.cms.isLocal
  ? createLocalDatabase()
  : createDatabase({
      gitProvider: new GitHubProvider({
        branch,
        owner: process.env.GITHUB_OWNER!,
        repo: process.env.GITHUB_REPO!,
        token: process.env.GITHUB_PERSONAL_ACCESS_TOKEN!,
        rootPath: "sites/baseline"
      }),
      databaseAdapter: new MongodbLevel({
        collectionName: "tinacms",
        dbName: "tinacms",
        mongoUri: process.env.MONGODB_URI!,
      }),
      namespace: branch,
    });
