import { defineGraphqlConfig } from "@w3yz/tool-graphql";
import { getTinaGraphqlConfig } from "@w3yz/cms-tina/config/graphql-config";
import { getSaleorGraphqlConfig } from "@w3yz/ecom-saleor/config/graphql-config";

const config = defineGraphqlConfig({
  projects: {
    ...getTinaGraphqlConfig(),
    ...getSaleorGraphqlConfig(),
  },
});

export default config;
