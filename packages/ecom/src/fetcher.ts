import { fetchers } from "@w3yz/tools/graphql";
import { publicEnvironment } from "@w3yz/tools/environment";

export const fetcher = fetchers.createFetcher(publicEnvironment.ecom.api);
