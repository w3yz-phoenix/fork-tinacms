import { graphqlConfigTools } from "@w3yz/tools/graphql";
import { getSaleorGraphqlConfig } from "@w3yz/ecom/config";

const config = graphqlConfigTools.defineGraphqlConfig({
  projects: {
    ...getSaleorGraphqlConfig(),
  },
});

export default config;
