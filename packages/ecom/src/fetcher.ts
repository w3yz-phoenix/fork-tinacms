import { fetchers } from "@w3yz/tools/graphql";

export const fetcher = fetchers.createFetcher(
  process.env.NEXT_PUBLIC_SALEOR_API_URL ?? ""
);
