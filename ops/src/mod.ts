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
    const githubToken = Deno.env.get("GITHUB_TOKEN");
    const shop = Deno.env.get("SHOP_NAME") ?? "unknown";
    const filePath = path.resolve(
      GITOPS_DIR,
      `kustomize/shop/current/kustomization.yaml`
    );

    const generate01Config = () => {
      return `
        apiVersion: kustomize.config.k8s.io/v1beta1
        kind: Kustomization

        resources:
          - ./../base
          - ./ghcr-secret.yaml

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
        `;
    };

    const generate04StorefrontProductionConfig = () => {
      return `
        apiVersion: kustomize.config.k8s.io/v1beta1
        kind: Kustomization

        resources:
          - ./../base
          - ./ghcr-secret.yaml

        components:
          - ./../components/w3yz

        configMapGenerator:
          - name: storefront-config
              literals:
                - NODE_ENV=production
                - NEXT_PUBLIC_URL="https://${shop}.${domain}"
                - NEXT_PUBLIC_ECOM_API_URL="https://api.${shop}.${domain}/graphql/"
                - NEXT_PUBLIC_ECOM_NAME="${shop}"
                - NEXT_PUBLIC_CMS_BASE_URL="https://${shop}.${domain}"
                - NEXTAUTH_SECRET="change-me"

          - name: tinacms-config
            literals:
              - NODE_ENV=production
              - NEXT_PUBLIC_URL="https://${shop}.${domain}"
              - NEXT_PUBLIC_ECOM_API_URL="https://api.${shop}.${domain}/graphql/"
              - NEXT_PUBLIC_ECOM_NAME="${shop}"
              - NEXT_PUBLIC_CMS_BASE_URL="https://${shop}.${domain}"
              - NEXTAUTH_SECRET="change-me"
              - MONGODB_URI="mongodb://ferretdb:27017/tina"
              - GITHUB_OWNER=w3yz-phoenix
              - GITHUB_REPO=live
              - GITHUB_BRANCH=main
              - GITHUB_PERSONAL_ACCESS_TOKEN="${githubToken}"
              - TINA_PUBLIC_IS_LOCAL="false"
              - NEXT_PUBLIC_TINA_IS_LOCAL="false"

        namespace: w3yz-shop-${shop}
`;
    };

    await Deno.writeTextFile(filePath, generate01Config());
  });

export const mainCommand = new Command().command(
  "generate",
  generateShopKustomize
);
