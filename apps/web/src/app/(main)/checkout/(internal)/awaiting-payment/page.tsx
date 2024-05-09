import { Button } from "#shadcn/components/button";
import Link from "next/link";

export default function CheckoutAwaitingPaymentPage() {
  return (
    <div>
      <p>Iletisim Bilgileri</p>
      <Button asChild>
        <Link href="/checkout/address">Geri</Link>
      </Button>
    </div>
  );
}
