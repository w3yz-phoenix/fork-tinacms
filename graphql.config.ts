import { defineGraphqlConfig } from "@w3yz/tool-graphql";
import { getTinaGraphqlConfig } from "@w3yz/cms-tina";
import { getSaleorGraphqlConfig } from "@w3yz/ecom-saleor";

debugger;

const config = defineGraphqlConfig({
  projects: {
    ...getTinaGraphqlConfig(),
    ...getSaleorGraphqlConfig(),
  },
});

console.log("config: ", config);

export default config;
