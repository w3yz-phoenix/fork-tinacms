import { fetchers } from "@w3yz/tools/graphql";
import { publicEnvironment } from "@w3yz/tools/lib";

export const fetcher = fetchers.createFetcher(publicEnvironment.cms.graphql);
