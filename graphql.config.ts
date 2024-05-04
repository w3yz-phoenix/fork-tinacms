import { defineGraphqlConfig } from "@w3yz/tool-graphql";
import { getTinaGraphqlConfig } from "@w3yz/gql-tina/config/graphql-config";
import { getSaleorGraphqlConfig } from "@w3yz/gql-saleor/config/graphql-config";

const config = defineGraphqlConfig({
  projects: {
    ...getTinaGraphqlConfig(),
    ...getSaleorGraphqlConfig(),
  },
});

export default config;
