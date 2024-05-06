import { graphqlConfigTools } from "@w3yz/tools/graphql";
import { getSaleorGraphqlConfig } from "@w3yz/ecom/config";
import { getTinaGraphqlConfig } from "@w3yz/cms/config";

const config = graphqlConfigTools.defineGraphqlConfig({
  projects: {
    ...getSaleorGraphqlConfig(),
    ...getTinaGraphqlConfig(),
  },
});

export default config;
