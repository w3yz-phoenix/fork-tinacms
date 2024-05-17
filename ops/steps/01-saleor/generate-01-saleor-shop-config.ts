import { Command } from "https://deno.land/x/cliffy@v1.0.0-rc.4/command/mod.ts";
import * as path from "https://deno.land/std@0.224.0/path/mod.ts";

await new Command()
  .name("generate")
  .description("Generates kustomize file for a shop")
  .option("-d, --domain <path:string>", "Specific subdomain", {
    default: "beta.w3yz.dev",
  })
  .option("-s, --shop <shop?:string>", "Shop name")
  .action(async ({ domain, shop }) => {
    const shopName = (shop || Deno.env.get("SHOP_NAME")) ?? "unknown";
    const kustomize = /* yaml */ `
      apiVersion: kustomize.config.k8s.io/v1beta1
      kind: Kustomization
      namespace: w3yz-shop-${shopName}

      resources:
        - ./../../../base
        - ./ghcr-secret.yaml

      components:
        - ./../bootstrap

      configMapGenerator:
        - name: shop-config
          literals:
            - SHOP_NAME=${shopName}
            - API_ALLOWED_CLIENT_HOSTS="localhost,127.0.0.1,dashboard.${shopName}.${domain},${shopName}.${domain}"
            - API_ALLOWED_HOSTS="api,localhost,127.0.0.1,api.${shopName}.${domain}"
            - API_FQDN=api.${shopName}.${domain}
            - DASHBOARD_FQDN=dashboard.${shopName}.${domain}
            - STOREFRONT_FQDN=${shopName}.${domain}
            - API_URL=https://api.${shopName}.${domain}
            - API_GRAPHQL_URL="https://api.${shopName}.${domain}/graphql/"
            - DASHBOARD_URL=https://dashboard.${shopName}.${domain}
            - STOREFRONT_URL=https://${shopName}.${domain}
      `;

    await Deno.writeTextFile(
      path.resolve(
        path.dirname(path.fromFileUrl(import.meta.url)),
        "./gen/kustomization.yaml"
      ),
      kustomize
    );
  })
  .parse(Deno.args);
