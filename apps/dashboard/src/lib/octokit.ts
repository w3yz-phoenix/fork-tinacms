import "server-only";
import { Octokit } from "octokit";

export const octokit = new Octokit({
  auth: process.env.GITHUB_PERSONAL_ACCESS_TOKEN,
});

export const mainRepo = {
  owner: "w3yz-phoenix",
  repo: "live",
} as const;

export const mainGitTree = {
  ...mainRepo,
  tree_sha: "main",
} as const;

export async function getMainTree() {
  return await octokit.request(
    "GET /repos/{owner}/{repo}/git/trees/{tree_sha}",
    {
      ...mainGitTree,
      recursive: "true",
    }
  );
}

type CreateOrUpdateFileParams = {
  messageCreate: string;
  messageUpdate: string;
  onlyCreate?: boolean;
  contentAlreadyEncoded?: boolean;
  content: string;
  path: string;
};

export async function safeGetFileContent(path: string) {
  try {
    return await octokit.request(
      "GET /repos/{owner}/{repo}/git/blobs/{file_sha}",
      {
        ...mainGitTree,
        file_sha: path,
      }
    );
  } catch (e) {
    return;
  }
}

export async function createOrUpdateFileIfChanged({
  path,
  messageCreate,
  messageUpdate,
  onlyCreate = false,
  contentAlreadyEncoded = false,
  ...params
}: CreateOrUpdateFileParams) {
  const maybeTargetFile = await safeGetFileContent(path);

  const content = contentAlreadyEncoded
    ? params.content
    : Buffer.from(params.content).toString("base64");

  if (onlyCreate && maybeTargetFile?.status === 200) {
    console.log(`File ${path} already exists, skipping updating`);
    return;
  }

  if (
    maybeTargetFile?.status === 200 &&
    maybeTargetFile.data.content === content
  ) {
    console.log(`File ${path} already exists with the same content`);
    return;
  }

  const message =
    maybeTargetFile?.status === 200 ? messageUpdate : messageCreate;

  return octokit.rest.repos.createOrUpdateFileContents({
    ...mainRepo,
    path,
    message,
    content,
    sha: maybeTargetFile?.data?.sha ?? undefined,
  });
}
