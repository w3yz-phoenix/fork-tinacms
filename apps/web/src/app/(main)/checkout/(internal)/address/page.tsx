import { Button } from "#shadcn/components/button";
import Link from "next/link";

export default function CheckoutAddressPage() {
  return (
    <div>
      <p>Adres Bilgileri</p>

      <Button asChild>
        <Link href="/checkout/contact">Geri</Link>
      </Button>

      <Button asChild>
        <Link href="/checkout/awaiting-payment">Ileri</Link>
      </Button>
    </div>
  );
}
