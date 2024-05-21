import * as path from "https://deno.land/std@0.224.0/path/mod.ts";

const currentDir = path.dirname(path.fromFileUrl(import.meta.url));

export const PROJECT_ROOT = path.resolve(currentDir, "../../");

export const getGithubAuthToken = async (required = false) => {
  const githubTokenFromEnv = Deno.env.get("GITHUB_TOKEN");
  if (githubTokenFromEnv && githubTokenFromEnv.length > 0) {
    return githubTokenFromEnv;
  }

  if (!required) {
    return "";
  }

  const hasGithubCli = (
    await new Deno.Command("gh", { args: ["--version"] }).output()
  ).success;

  if (!hasGithubCli) {
    throw new Error("Please install GitHub CLI");
  }

  const isLoggedIn = (
    await new Deno.Command("gh", { args: ["auth", "status"] }).output()
  ).success;

  if (!isLoggedIn) {
    throw new Error("Please login to GitHub CLI");
  }

  const tokenOutput = await new Deno.Command("gh", {
    args: ["auth", "token"],
  }).output();

  return new TextDecoder().decode(tokenOutput.stdout).trim();
};

export const getMongodbPort = async (namespace: string, required = false) => {
  const mongodbPortFromEnv = Deno.env.get("MONGODB_PORT");
  if (mongodbPortFromEnv && mongodbPortFromEnv.length > 0) {
    return mongodbPortFromEnv;
  }

  if (!required) {
    return "27017";
  }

  const isKubeCtlConnected = (
    await new Deno.Command("kubectl", {
      args: ["get", "nodes"],
    }).output()
  ).success;

  if (!isKubeCtlConnected) {
    throw new Error("Please login to kubectl");
  }

  const portOutput = (
    await new Deno.Command("kubectl", {
      args: [
        "get",
        "-n",
        namespace,
        "service",
        "ferretdb-exposed",
        "-o",
        "jsonpath='{.spec.ports[0].nodePort}'",
      ],
    }).output()
  ).stdout;

  return new TextDecoder().decode(portOutput).trim();
};
