"use client";
import { IconCheck, IconChevronDown, IconChevronUp } from "@tabler/icons-react";
import Image from "next/image";
import { useState } from "react";

function OrderDetail() {
  return (
    <div className="flex max-w-[897px] flex-col items-stretch rounded-none border-t border-solid border-t-[#DCDCDC] bg-white p-4 lg:p-7">
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <div className="my-auto grow whitespace-nowrap text-xl text-[#525252]">
          Sipariş Numarası: <span className="text-[#989898]">294249402</span>
        </div>
        <div className="flex items-stretch justify-center gap-4 self-stretch">
          <div className="flex items-center justify-between gap-3 rounded py-2 text-emerald-500">
            <IconCheck />
            <div className="text-base font-medium">Sipariş Verildi</div>
          </div>
        </div>
        <div className="flex flex-col gap-4 sm:flex-row">
          <button
            type="button"
            className="whitespace-nowrap rounded border border-[#BDBDBD] px-5 py-2 text-[14px] font-medium text-[#464646]"
          >
            Faturayı Görüntüle
          </button>
          <button
            type="button"
            className="whitespace-nowrap rounded border border-[#BDBDBD] px-5 py-2 text-[14px] font-medium text-[#464646]"
          >
            İade Et
          </button>
        </div>
      </div>

      {/* 4 LÜ ÖZET */}
      <div className="grid grid-cols-1 gap-2 border-b border-solid border-b-[#DCDCDC] py-8 text-base text-[#525252] md:grid-cols-2 md:gap-5 lg:grid-cols-3">
        <div className="flex items-stretch gap-2">
          <div>Sipariş Tarihi</div>
          <div className="text-[#989898]">21.02.2023</div>
        </div>
        <div className="flex items-stretch gap-2">
          <div>Tutar</div>
          <div className="text-[#989898]">3.573,00₺</div>
        </div>
        <div className="flex items-stretch gap-2">
          <div>Alıcı</div>
          <div className="text-[#989898]">Şeydan Bayrak Aydoğdu</div>
        </div>
        <div className="flex items-stretch gap-2">
          <div>Teslimat No</div>
          <div className="text-[#989898]">3582435</div>
        </div>
        <div className="flex items-stretch gap-2">
          <div>Kargo Firması</div>
          <div className="text-[#989898]">Yurtiçi Kargo</div>
        </div>
        <div className="flex items-stretch gap-2">
          <div>Sipariş Özeti</div>
          <div className="text-[#989898]">1 Teslimat, 3 Ürün</div>
        </div>
      </div>

      {/* ÜRÜNLER */}
      <div className="mt-6 flex flex-col items-stretch rounded border border-solid border-[#DCDCDC] p-2 sm:p-4">
        <div className="text-base text-[#525252]">Ürünler</div>
        <div className="my-4">
          <div className="flex justify-between gap-3 border-b border-[#DCDCDC] py-5">
            <div className="max-h-[92px] max-w-[133px] sm:h-[109px] sm:w-[157px] ">
              <Image
                src={"https://via.placeholder.com/157x109"}
                alt={""}
                width={157}
                height={109}
                className="size-full"
              />
            </div>
            {/* <div className="flex max-w-[180px] grow flex-col items-start justify-start gap-2 text-base text-[#525252]">
              <div className="text-[14px] font-medium text-[#525252] sm:hidden">
                3.574,00₺
              </div>
              <div className="font-medium">deneme</div>
              <div>
                Varyant Adı: <span className="text-[#989898]">deneme</span>
              </div>
              <div>
                Kartela Seçimi : <span className="text-[#989898]">dsa</span>
              </div>
              <div>Kumaş Rengi : Kahverengi</div>
            </div>
            <div className="hidden text-[14px] font-medium text-[#525252] sm:block md:text-xl">
              3.574,00₺
            </div> */}
          </div>
        </div>
      </div>

      {/* ÖDEME VE TESLİMAT BİLGİLERİ */}
      <div className="mt-6">
        <div className="flex flex-col gap-5 md:flex-row">
          <div className="flex w-6/12 flex-col items-stretch max-md:w-full">
            <div className="flex w-full grow flex-col items-start self-stretch rounded border border-solid border-[#DCDCDC] p-4">
              <div className="text-base text-[#525252]">Teslimat Bilgileri</div>
              <div className="mt-4 text-xs text-[#525252]">Fatura Adresi</div>
              <div className="my-2 text-xs text-[#989898]">
                <div className="text-xs text-[#989898]">
                  Aydınlık Sok. No: 16/3 Kat: 1 Daire:3
                </div>
              </div>
              <div className="mt-4 text-xs text-[#525252]">Teslimat Adresi</div>
              <div className="my-2 text-xs text-[#989898]">
                <div className="text-xs text-[#989898]">
                  Aydınlık Sok. No: 16/3 Kat: 1 Daire:3
                </div>
              </div>
            </div>
          </div>
          <div className="flex w-6/12 flex-col items-stretch max-md:w-full">
            <div className="mx-auto flex w-full grow flex-col items-start rounded border border-solid border-[#DCDCDC] px-4 pb-12 pt-4">
              <div className="self-stretch text-base text-[#525252]">
                Ödeme Bilgileri
              </div>
              <div className="mt-6 flex items-stretch gap-2 self-start">
                <div className="grow whitespace-nowrap text-xs text-[#525252]">
                  Kredi Kartı
                </div>
                <div className="grow whitespace-nowrap text-xs text-[#989898]">
                  Tek Çekim
                </div>
              </div>
              <div className="mt-4 flex flex-col items-stretch self-stretch border-b border-solid border-b-[#DCDCDC] pb-4">
                <div className="flex items-stretch justify-between gap-5">
                  <div className="text-xs text-[#989898]">Kargo</div>
                  <div className="text-xs text-[#989898]">120₺</div>
                </div>
                <div className="mt-2 flex items-stretch justify-between gap-5">
                  <div className="text-xs text-[#989898]">Ürün Toplam</div>
                  <div className="text-xs text-[#989898]">3.454,00₺</div>
                </div>
              </div>
              <div className="mb-4 mt-2 flex items-stretch justify-between gap-5 self-stretch">
                <div className="text-[12px] font-normal text-[#4C4F52]">
                  Toplam
                </div>
                <div className="text-[12px] font-normal text-[#4C4F52]">
                  3.574,00₺
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export function OrderItemCard() {
  const [showDetails, setShowDetails] = useState(false);
  return (
    <div className="mb-5 flex max-w-[897px] flex-col rounded border border-solid border-[#DCDCDC] bg-white">
      <div className="flex p-4 lg:p-6">
        <div className="h-[90px] w-[70px]">
          <Image
            width={70}
            height={90}
            loading="lazy"
            src={"https://via.placeholder.com/157x109"}
            alt={"Ürün"}
            className="size-full"
          />
        </div>
        <div className="flex w-full items-center justify-between px-2 text-base placeholder:lg:px-5">
          <div className="ml-[5%] flex flex-col items-start justify-between gap-2 text-[#525252] sm:ml-[15%] md:ml-5 md:flex-row md:items-center md:gap-5 lg:gap-10">
            <div className="flex flex-row max-md:gap-2 md:flex-col">
              <p>Sipariş Tarihi</p>
              <p className="text-[#989898] md:mt-2">21.02.2023</p>
            </div>
            <div className="flex flex-row max-md:gap-2 md:flex-col">
              <p>Durum</p>
              <p className="text-[#989898] md:mt-2">Sipariş Verildi</p>
            </div>
            <div className="flex flex-row max-md:gap-2 md:flex-col">
              <p>Tutar</p>
              <p className="text-[#989898] md:mt-2">3.573,00₺</p>
            </div>
          </div>
          <div
            onClick={() => setShowDetails((previous) => !previous)}
            className="my-auto hidden cursor-pointer text-end text-base font-medium text-[#525252] md:block lg:text-lg"
          >
            {showDetails ? "Sipariş Detayını Kapat" : "Sipariş Detayını Gör"}
          </div>
          <div
            onClick={() => setShowDetails((previous) => !previous)}
            className="my-auto cursor-pointer text-[#525252] md:hidden "
          >
            {showDetails ? <IconChevronDown /> : <IconChevronUp />}
          </div>
        </div>
      </div>
      <div>{showDetails && <OrderDetail />}</div>
    </div>
  );
}
