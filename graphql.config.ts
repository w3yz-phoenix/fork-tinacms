import { defineGraphqlConfig } from "@w3yz/tool-graphql";
import { getTinaGraphqlConfig } from "@w3yz/cms-tina";

export default defineGraphqlConfig({
  projects: {
    ...getTinaGraphqlConfig(),
  },
});
