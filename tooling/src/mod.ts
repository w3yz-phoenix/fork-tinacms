import { Command } from "https://deno.land/x/cliffy@v1.0.0-rc.4/command/mod.ts";
import * as path from "https://deno.land/std/path/mod.ts";

const GITOPS_DIR = path.resolve(Deno.cwd(), "../shop");

const generateShopKustomize = new Command()
  .name("generate")
  .description("Generates kustomize file for a shop")
  .option("-d, --domain <path:string>", "Specific subdomain", {
    default: "beta.w3yz.dev",
  })
  // .arguments("<shop:string>")
  .action(async ({ domain }) => {
    const shop = Deno.env.get("SHOP_NAME") ?? "unknown";
    const filePath = path.resolve(
      GITOPS_DIR,
      `kustomize/shop/current/kustomization.yaml`
    );

    const kustomize = `
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ./../base

components:
  - ./../components/w3yz

configMapGenerator:
  - name: shop-config
    literals:
      - SHOP_NAME=${shop}
      - API_ALLOWED_CLIENT_HOSTS="localhost,127.0.0.1,dashboard.${shop}.${domain},${shop}.${domain}"
      - API_ALLOWED_HOSTS="api,localhost,127.0.0.1,api.${shop}.${domain}"
      - API_FQDN=api.${shop}.${domain}
      - DASHBOARD_FQDN=dashboard.${shop}.${domain}
      - STOREFRONT_FQDN=${shop}.${domain}
      - API_URL=https://api.${shop}.${domain}
      - API_GRAPHQL_URL="https://api.${shop}.${domain}/graphql/"
      - DASHBOARD_URL=https://dashboard.${shop}.${domain}
      - STOREFRONT_URL=https://${shop}.${domain}

namespace: w3yz-shop-${shop}
    `;

    await Deno.writeTextFile(filePath, kustomize);
  });

export const mainCommand = new Command().command(
  "generate",
  generateShopKustomize
);
