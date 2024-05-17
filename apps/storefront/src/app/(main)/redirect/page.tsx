"use server";

import { notFound, redirect } from "next/navigation";
import { Suspense, type ComponentType } from "react";
import { cookies } from "next/headers";
import { getStringIfNotEmpty, safeJsonParse } from "@w3yz/tools/lib";

import { RedirectToPayment } from "./components/redirect-to-payment";

const DELAY_SECONDS = 5;

async function DelayedRedirect({
  url,
  delay = DELAY_SECONDS * 1000,
}: {
  url: string;
  delay?: number;
}) {
  await new Promise((resolve) => setTimeout(resolve, delay));

  return redirect(url);
}

const redirectPagesMap = {
  payment: RedirectToPayment,
} as const;

const defaultRedirectPage = RedirectToPayment;

export default async function ExternalRedirectPage() {
  const redirectInfo = safeJsonParse(
    cookies().get("redirectInformation")?.value
  );

  if (!redirectInfo) {
    return notFound();
  }

  const url = getStringIfNotEmpty(redirectInfo.url);
  const type = getStringIfNotEmpty(redirectInfo.type);

  if (!url || !type) {
    return notFound();
  }

  const RedirectDesign =
    redirectPagesMap[type as keyof typeof redirectPagesMap] ??
    (defaultRedirectPage as ComponentType<{ url: string }>);

  return (
    <div>
      <RedirectDesign url={url} />
      <Suspense>
        <DelayedRedirect url={url} delay={DELAY_SECONDS * 1000} />
      </Suspense>
    </div>
  );
}
