import {
  SaleorAuthClient,
  StorageRepository,
  createSaleorAuthClient,
} from "@saleor/auth-sdk";
import { getNextServerCookiesStorage } from "@saleor/auth-sdk/next/server";

export const nextServerCookiesStorage =
  getNextServerCookiesStorage() as StorageRepository;

export const saleorAuthClient = createSaleorAuthClient({
  saleorApiUrl: "https://dev-shop-api.w3yz.dev/graphql/",
  refreshTokenStorage: nextServerCookiesStorage,
  accessTokenStorage: nextServerCookiesStorage,
}) as SaleorAuthClient;
