import { invariant, isPresent } from "@w3yz/tools/lib";
import path from "path";
import {
  octokit,
  mainGitTree,
  mainRepo,
  getMainTree,
  createOrUpdateFileIfChanged,
} from "../octokit";
import { StoreManifestSchema, type StoreManifestType } from "./schema";
import jsYaml from "js-yaml";
import type { z } from "zod";

type Maybe<T> = T | null | undefined;

async function parseManifest(
  file: Maybe<{ url: string; content: Maybe<string> }>
) {
  try {
    invariant(file?.content, "File content is missing");

    const content = Buffer.from(file.content, "base64").toString();
    const rawManifest = jsYaml.load(content);

    invariant(rawManifest, "Could not parse manifest");

    const data = await StoreManifestSchema.parseAsync(rawManifest);

    return { success: true, data };
  } catch (e) {
    console.error(e);
    return { success: false, error: e };
  }
}

async function getManifests() {
  const tree = await octokit.request(
    "GET /repos/{owner}/{repo}/git/trees/{tree_sha}",
    {
      ...mainGitTree,
      recursive: "true",
    }
  );

  const manifestFiles = await Promise.all(
    tree.data.tree
      .filter((file) => file.path && path.basename(file.path) === "w3yz.yaml")
      .map(async (file) => {
        if (!file.sha) return null;

        const manifest = await octokit.request(
          "GET /repos/{owner}/{repo}/git/blobs/{file_sha}",
          {
            ...mainGitTree,
            file_sha: file.sha,
          }
        );

        return manifest.data;
      })
  );

  const manifests = await Promise.all(manifestFiles.map(parseManifest));

  return manifests.map((m) => m.data).filter(isPresent);
}

async function copyStore(from: string, to: string) {
  const stores = await getStores();
  const fromStore = stores.find((s) => s.slug === from);
  const toStore = stores.find((s) => s.slug === to);

  invariant(fromStore, "From store not found");
  invariant(toStore, "To store not found");

  const fromDomain = fromStore.domains.find((d) => d.type === "builtin");
  const toDomain = toStore.domains.find((d) => d.type === "builtin");

  invariant(fromDomain, "From domain not found");
  invariant(toDomain, "To domain not found");

  const mainTree = await getMainTree();

  const sourceFiles = mainTree.data.tree.filter((file) => {
    if (!file.path) return false;

    return (
      file.type === "blob" &&
      file.path?.startsWith(`sites/${fromDomain.fqdn}`) &&
      path.basename(file.path) !== "w3yz.yaml"
    );
  });

  const copyFileList = sourceFiles
    .map((sourceFile) => {
      if (!sourceFile.path) return;

      const targetPath = sourceFile.path.replace(
        `sites/${fromDomain.fqdn}`,
        `sites/${toDomain.fqdn}`
      );

      return [sourceFile.path, targetPath];
    })
    .filter(isPresent);

  await Promise.all(
    copyFileList.map(async ([source, target]) => {
      const sourceFile = await octokit.rest.repos.getContent({
        ...mainRepo,
        path: source,
      });

      if (sourceFile.status !== 200 || !sourceFile.data) {
        console.error(`File ${source} not found`);
        return;
      }

      await createOrUpdateFileIfChanged({
        content: (sourceFile.data as any).content,
        path: target,
        contentAlreadyEncoded: true,
        messageCreate: `Copy ${source} to ${target}`,
        messageUpdate: `Copy ${source} to ${target}`,
      });
    })
  );
}

export async function getStores() {
  return getManifests();
}

export async function deleteStore(slug: string) {
  const stores = await getStores();
  const store = stores.find((s) => s.slug === slug);

  invariant(store, "Store not found");

  const mainTree = await getMainTree();
  const filesToDelete = mainTree.data.tree.filter((file) =>
    file.path?.startsWith(`sites/${store.domains[0].fqdn}`)
  );

  await Promise.all(
    filesToDelete.map(async (file) => {
      if (!file.path || !file.sha) return;

      await octokit.rest.repos.deleteFile({
        ...mainRepo,
        path: file.path,
        message: `Delete ${file.path}`,
        sha: file.sha,
      });
    })
  );
}

export async function createStore(
  params: Pick<z.infer<typeof StoreManifestSchema>, "name" | "slug">
) {
  const builtinDomain = `${params.slug}.beta.w3yz.dev`;

  const manifestCreationParams: z.infer<typeof StoreManifestSchema> = {
    name: params.name,
    slug: params.slug,
    createdAt: new Date(),
    domains: [
      {
        fqdn: builtinDomain,
        type: "builtin",
        disabled: false,
      },
    ],
  };

  const manifest = await StoreManifestSchema.parseAsync(manifestCreationParams);
  const newContent = jsYaml.dump(manifest);

  await createOrUpdateFileIfChanged({
    path: `sites/${builtinDomain}/w3yz.yaml`,
    content: newContent,
    onlyCreate: true,
    messageCreate: `Create ${manifest.name} store`,
    messageUpdate: `Update ${manifest.name} store`,
  });

  await copyStore("template", params.slug);
}

export async function updateStore(
  existingStore: StoreManifestType,
  updateParams: Partial<StoreManifestType>
) {
  const updatedStore = { ...existingStore, ...updateParams };

  const newContent = jsYaml.dump(updatedStore);

  await createOrUpdateFileIfChanged({
    path: `sites/${updatedStore.domains[0].fqdn}/w3yz.yaml`,
    content: newContent,
    messageCreate: `Create ${updatedStore.name} store`,
    messageUpdate: `Update ${updatedStore.name} store`,
    onlyCreate: false,
    contentAlreadyEncoded: false,
  });
}

export async function createOrUpdateStore(
  params: Pick<z.infer<typeof StoreManifestSchema>, "name" | "slug">
) {
  const stores = await getStores();
  const store = stores.find((s) => s.slug === params.slug);

  if (store) {
    return updateStore(store, params);
  }

  return createStore(params);
}
