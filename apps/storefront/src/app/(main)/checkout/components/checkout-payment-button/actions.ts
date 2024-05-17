"use server";

import {
  usePaymentGatewayInitializeMutation,
  useTransactionInitializeMutation,
  type SaleorGraphql_TransactionEvent,
} from "@w3yz/ecom/api";
import { invariant } from "@w3yz/tools/lib";

import { getCurrentCheckout } from "#storefront/lib/checkout/checkout.query";

export type TransactionData = {
  status?: string;
  locale?: string;
  systemTime?: number;
  conversationId?: string;
  token?: string;
  tokenExpireTime?: number;
  paymentPageUrl: string;
  payWithIyzicoPageUrl?: string;
  [k: string]: unknown;
};

export type TransactionEventDetails = {
  id: string;
  data: TransactionData | null | undefined;
  event: Partial<SaleorGraphql_TransactionEvent> | null | undefined;
};

async function getAvailablePaymentGateways(checkoutId: string) {
  const response = await usePaymentGatewayInitializeMutation.fetcher({
    id: checkoutId,
  })();

  const gatewayConfigs = response?.paymentGatewayInitialize?.gatewayConfigs;

  invariant(gatewayConfigs, "Gateway configs must be defined");

  const availableGatewayConfigs = gatewayConfigs.filter(
    (config) => config.errors?.length === 0
  );

  invariant(
    availableGatewayConfigs.length > 0,
    "There must be at least one available gateway config"
  );

  return availableGatewayConfigs;
}

export async function completeCheckout() {
  const checkout = await getCurrentCheckout();

  const availableGatewayConfigs = await getAvailablePaymentGateways(
    checkout.id
  );

  // TODO: Once we have multiple payment gateways, we should let the user choose one
  const gatewayConfig = availableGatewayConfigs[0];

  const response = await useTransactionInitializeMutation.fetcher({
    id: checkout.id,
    paymentGatewayId: gatewayConfig.id,
  })();

  invariant(
    response.transactionInitialize?.transaction?.id,
    "Transaction ID is undefined"
  );

  const { transaction, transactionEvent } = response.transactionInitialize;

  const transactionData = response.transactionInitialize
    ?.data as TransactionData;

  invariant(
    transaction?.id && transactionData?.paymentPageUrl && transactionEvent?.id,
    "Ödeme tamamlanamadı. Lütfen tekrar deneyin."
  );

  const transactionEventDetails = {
    id: response.transactionInitialize.transaction?.id,
    event: response.transactionInitialize.transactionEvent,
    data: transactionData,
  };

  return transactionEventDetails;
}
