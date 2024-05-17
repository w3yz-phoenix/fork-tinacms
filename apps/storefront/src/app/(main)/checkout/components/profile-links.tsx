"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

import { cn } from "#shadcn/lib/utils";
export const ProfileNavigationLink = () => {
  const pathName = usePathname();
  return (
    <div className="max-w-[400px]">
      <div className="flex flex-col items-start justify-center gap-3">
        <h3 className="text-3xl font-semibold leading-[38px] text-[#292929]">
          Kişisel Bilgiler
        </h3>
        <p className="text-base font-normal leading-normal text-[#656565]">
          Kişisel bilgilerinizi güncelleyin.
        </p>
      </div>
      <div className="mt-8">
        <div
          className={cn(
            "flex flex-col items-start justify-center gap-2 p-5 hover:bg-[#F5F6F6]",
            pathName === "/profile/personal-info" ? "bg-[#F5F6F6]" : ""
          )}
        >
          <Link
            href={"/profile/personal-info"}
            className="w-full text-xl font-semibold leading-[38px] text-[#292929]"
          >
            Kişisel Bilgiler
          </Link>
          <p className="text-base font-normal leading-normal text-[#656565]">
            Kişisel bilgilerinizi güncelleyin.
          </p>
        </div>
        <div
          className={cn(
            "flex flex-col items-start justify-center gap-2 p-5 hover:bg-[#F5F6F6]",
            pathName === "/profile/address" ? "bg-[#F5F6F6]" : ""
          )}
        >
          <Link
            href={"/profile/address"}
            className="w-full text-xl font-semibold leading-[38px] text-[#292929]"
          >
            Adres Bilgileri
          </Link>
          <p className="text-base font-normal leading-normal text-[#656565]">
            Yeni adres oluştur veya düzenleyin.
          </p>
        </div>
        <div
          className={cn(
            "flex flex-col items-start justify-center gap-2 p-5 hover:bg-[#F5F6F6]",
            pathName === "/profile/password-reset" ? "bg-[#F5F6F6]" : ""
          )}
        >
          <Link
            href={"/profile/password-reset"}
            className="text-xl font-semibold leading-[38px] text-[#292929]"
          >
            Parola İşlemleri
          </Link>
          <p className="text-base font-normal leading-normal text-[#656565]">
            Parolanızı Güncelleyin, güvenliğiniz için her 6 ayda bir yeni parola
            belirleyin.
          </p>
        </div>
        <div
          className={cn(
            "flex flex-col items-start justify-center gap-2 p-5 hover:bg-[#F5F6F6]",
            pathName === "/profile/orders" ? "bg-[#F5F6F6]" : ""
          )}
        >
          <Link
            href={"/profile/orders"}
            className="text-xl font-semibold leading-[38px] text-[#292929]"
          >
            Siparişler
          </Link>
          <p className="text-base font-normal leading-normal text-[#656565]">
            Tüm sipariş geçmişinizi görün ve takip edin.
          </p>
        </div>
      </div>
      <Link
        className="mt-[52px] inline-flex w-full items-center justify-start gap-2 border-t border-[#656565] px-[18px] py-2.5 text-base font-medium leading-normal text-[#292929]"
        href=""
      >
        Çıkış yap
      </Link>
    </div>
  );
};
