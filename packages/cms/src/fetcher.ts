import { fetchers } from "@w3yz/tools/graphql";

export const fetcher = fetchers.createFetcher(
  "http://localhost:3000/api/tina/gql"
);
