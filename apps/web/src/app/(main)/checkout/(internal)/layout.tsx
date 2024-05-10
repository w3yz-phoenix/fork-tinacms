import { notFound } from "next/navigation";

import { getCurrentCheckout } from "#web/lib/checkout/checkout.query";

import { CheckoutSummary } from "../components/checkout-summary";

export default async function CheckoutLayout(props: {
  children: React.ReactNode;
}) {
  try {
    await getCurrentCheckout();
  } catch {
    return notFound();
  }

  return (
    <div className="w-full">
      <div className="flex h-full flex-col items-stretch justify-between lg:flex-row">
        <div className="h-full basis-1/2 px-4 py-[6%] sm:px-[6%]">
          <div className="flex flex-col items-start">{props.children}</div>
        </div>
        <div className="flex min-h-screen bg-[#F6F6F6] max-sm:items-stretch sm:flex-1">
          <CheckoutSummary />
        </div>
      </div>
    </div>
  );
}
