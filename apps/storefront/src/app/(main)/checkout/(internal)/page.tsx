import Link from "next/link";

import { Button } from "#shadcn/components/button";

export default function CheckoutPage() {
  return (
    <div>
      <p>Satın almaya devam etmek için satın alma yönetminizi seçin </p>
      <div className="mt-[30px] flex w-full gap-3">
        <Button asChild className="cursor-not-allowed opacity-10">
          <Link href="#">Giriş Yap</Link>
        </Button>
        <Button asChild>
          <Link href="/checkout/contact">Kaydolmadan Al</Link>
        </Button>
      </div>
    </div>
  );
}
