"use client";

import { tinaField } from "tinacms/dist/react";
import Link from "next/link";

import type { TinaGraphql_PageBlocksProfileNavigation } from "@w3yz/cms/api";

export const ProfileNavigationBlock = ({
  block,
}: {
  block: TinaGraphql_PageBlocksProfileNavigation;
}) => {
  return (
    <div className="max-w-[400px]" data-tina-field={tinaField(block)}>
      <div className="flex flex-col items-start justify-center gap-3">
        <h3 className="text-3xl font-semibold leading-[38px] text-[#292929]">
          {block.mainTitle}
        </h3>
        <p className="text-base font-normal leading-normal text-[#656565]">
          Hesabınıza ait temel verilerinizi düzenleyin
        </p>
      </div>
      <div>
        <div className={"flex flex-col items-start justify-center gap-2 p-5"}>
          <Link
            href={""}
            className="w-full text-xl font-semibold leading-[38px] text-[#292929]"
          >
            Adres Bilgileri
          </Link>
          <p className="text-base font-normal leading-normal text-[#656565]">
            Yeni adres oluştur veya düzenleyin.
          </p>
        </div>
        <div className={"flex flex-col items-start justify-center gap-2 p-5"}>
          <Link
            href={""}
            className="text-xl font-semibold leading-[38px] text-[#292929]"
          >
            Parola İşlemleri
          </Link>
          <p className="text-base font-normal leading-normal text-[#656565]">
            Parolanızı Güncelleyin, güvenliğiniz için her 6 ayda bir yeni parola
            belirleyin.
          </p>
        </div>
        <div className={"flex flex-col items-start justify-center gap-2 p-5"}>
          <Link
            href={""}
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
