import Image from "next/image";
import Link from "next/link";

interface RedirectToPaymentProperties {
  url: string;
}

export async function RedirectToPayment({ url }: RedirectToPaymentProperties) {
  return (
    <div className="flex h-screen w-full flex-col items-center justify-center bg-[#F5F6F6] max-lg:gap-10 lg:flex-row">
      <Image
        width={435}
        height={370}
        className="mr-[5%] hidden h-full lg:block"
        alt="Hata"
        src="/assets/redirect-payment.png"
      />
      <Image
        width={235}
        height={200}
        className="block h-full pt-[50px] lg:hidden"
        alt="Hata"
        src="/assets/redirect-payment.png"
      />
      <div className=" mb-[100px] mr-0 flex max-w-[370px] flex-col items-center lg:mb-0 lg:mr-[100px]">
        <p className="text-4xl font-normal text-[#252627]">Ödeme Sayfasına</p>
        <p className="text-4xl font-normal text-[#252627]">
          Yönlendiriliyorsunuz
        </p>
        <p className="mt-[13px] text-xl font-medium text-[#83878D]">
          Eğer yönlendirme yapılmazsa,
        </p>
        <p className="text-xl font-medium text-[#83878D]">
          lütfen ‘’Adrese Git’’ butonuna tıklayın.
        </p>
        <Link
          className="mt-[29px] flex h-[40px] w-[171px] items-center justify-center rounded bg-[#252627] text-[16px] font-medium text-[#F5F6F6]"
          href={url}
        >
          Adrese Git
        </Link>
      </div>
    </div>
  );
}
