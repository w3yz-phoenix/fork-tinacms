import { createFetcher } from "@w3yz/tool-graphql";

export const fetcher = createFetcher(
  process.env.NEXT_PUBLIC_SALEOR_API_URL ?? ""
);
