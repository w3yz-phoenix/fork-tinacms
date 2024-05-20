import { Command } from "https://deno.land/x/cliffy@v1.0.0-rc.4/command/mod.ts";
import * as path from "https://deno.land/std@0.224.0/path/mod.ts";

const currentDir = path.dirname(path.fromFileUrl(import.meta.url));

await new Command()
  .name("generate")
  .description("Generates kustomize file for a shop")
  .option("-d, --root-domain <string?>", "Specific subdomain", {
    default: "beta.w3yz.dev",
  })
  .option("-g, --github-token <string?>", "Github Token")
  .option("-s, --shop-name <string?>", "Shop name")
  .option("-p, --profile <string?>", "Run Profile")
  .action(async (params) => {
    const githubToken =
      (params.githubToken || Deno.env.get("MY_PERSONAL_GITHUB_TOKEN")) ??
      "unknown";
    const rootDomain =
      (params.rootDomain || Deno.env.get("NEXT_PUBLIC_ROOT_DOMAIN")) ??
      "unknown";
    const shopName =
      (params.shopName || Deno.env.get("NEXT_PUBLIC_SHOP_NAME")) ?? "unknown";

    const dockerConfigJson = {
      auths: {
        "ghcr.io": {
          username: "yasinuslu",
          password: githubToken,
          email: "nepjua@gmail.com",
          auth: btoa(`yasinuslu:${githubToken}`),
        },
      },
    };

    await Deno.writeTextFile(
      path.resolve(currentDir, "../gen/.dockerconfigjson"),
      JSON.stringify(dockerConfigJson)
    );

    const shouldPatchStorefront = params.profile === "release";

    const patchesString = /* yaml */ `
patches:
  - patch: |-
      - op: replace
        path: /spec/template/spec/containers/0/image
        value: ghcr.io/w3yz-phoenix/w3yz:main
      - op: replace
        path: /spec/template/spec/containers/0/ports/0/containerPort
        value: 3000
      - op: replace
        path: /spec/template/spec/containers/0/workingDir
        value: /apps/storefront
    target:
      kind: Deployment
      name: storefront
  - patch: |-
      - op: replace
        path: /spec/template/spec/containers/0/image
        value: ghcr.io/w3yz-phoenix/w3yz:main
      - op: replace
        path: /spec/template/spec/containers/0/ports/0/containerPort
        value: 3000
      - op: replace
        path: /spec/template/spec/containers/0/workingDir
        value: /apps/tinacms
    target:
      kind: Deployment
      name: tinacms
`;

    const kustomize = /* yaml */ `
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: w3yz-shop-${shopName}

resources:
  - ./../base

components:
  - ./../kustomize-generation/bootstrap

${shouldPatchStorefront ? patchesString : ""}

secretGenerator:
  - name: ghcr-secret
    files:
      - .dockerconfigjson
    type: kubernetes.io/dockerconfigjson

configMapGenerator:
  - name: shop-config
    literals:
      - NEXT_PUBLIC_SHOP_NAME=${shopName}
      - API_ALLOWED_CLIENT_HOSTS="localhost,127.0.0.1,dashboard.${shopName}.${rootDomain},${shopName}.${rootDomain}"
      - API_ALLOWED_HOSTS="api,localhost,127.0.0.1,api.${shopName}.${rootDomain}"
      - API_FQDN=api.${shopName}.${rootDomain}
      - DASHBOARD_FQDN=dashboard.${shopName}.${rootDomain}
      - STOREFRONT_FQDN=${shopName}.${rootDomain}
      - API_URL=https://api.${shopName}.${rootDomain}
      - API_GRAPHQL_URL="https://api.${shopName}.${rootDomain}/graphql/"
      - DASHBOARD_URL=https://dashboard.${shopName}.${rootDomain}
      - STOREFRONT_URL=https://${shopName}.${rootDomain}

  - name: storefront-config
    literals:
      - NODE_ENV=production
      - SHOP_DOMAIN="${shopName}.${rootDomain}"
      - NEXT_PUBLIC_URL="https://${shopName}.${rootDomain}"
      - NEXT_PUBLIC_ECOM_API_URL="https://api.${shopName}.${rootDomain}/graphql/"
      - NEXT_PUBLIC_ECOM_NAME="${shopName}"
      - NEXT_PUBLIC_SHOP_DOMAIN="${shopName}.${rootDomain}"
      - NEXT_PUBLIC_CMS_BASE_URL="https://${shopName}.${rootDomain}"
      - NEXTAUTH_SECRET="change-me"
      - MONGODB_URI="mongodb://ferretdb:27017/${shopName}"
      - GITHUB_OWNER=w3yz-phoenix
      - GITHUB_REPO=live
      - GITHUB_BRANCH=main
      - GITHUB_PERSONAL_ACCESS_TOKEN="${githubToken}"
      - TINA_PUBLIC_IS_LOCAL="false"
      - NEXT_PUBLIC_TINA_IS_LOCAL="false"
`;

    await Deno.writeTextFile(
      path.resolve(
        path.dirname(path.fromFileUrl(import.meta.url)),
        "../gen/kustomization.yaml"
      ),
      kustomize
    );
  })
  .parse(Deno.args);
