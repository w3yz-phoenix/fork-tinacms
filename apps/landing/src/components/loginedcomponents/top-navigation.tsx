"use client";

import Image from "next/image";

import WhiteButton, { BlueButton, PurpleButton } from "./buttons";
import PageLinks from "./page-links";

interface properties {
  label?: string;
  description?: any;
  pageLinks?: any;
  noButtons?: any;
  page?: string;
  orderStatus?: any;
  backLink?: any;
}

export default function TopNavigation({
  label,
  description,
  pageLinks,
  noButtons,
  page,
  orderStatus,
  backLink,
}: properties) {
  return (
    <div className="w-full">
      <div className="h-[8px]">
        <Image
          src={"/assets/Swatch.png"}
          width={100}
          height={8}
          alt=""
          className="w-full"
          style={{
            maxWidth: "100%",
            height: "auto",
          }}
        />
      </div>

      <div className="flex items-center justify-between p-6">
        <div>
          <div dangerouslySetInnerHTML={{ __html: backLink }} />
          <label className="text-[32px] text-[#24262D] font-medium mb-1 flex items-center gap-x-3">
            {label}
            {orderStatus ? (
              <div
                className={`bg-[#EDE8FF] rounded-[50px] px-[14px] py-[10px] text-[#320B6A] text-[10px] font-medium max-w-fit`}
              >
                Onaylanmadı
              </div>
            ) : (
              ""
            )}
          </label>
          <p
            className="text-[#011B31] text-[16px]"
            dangerouslySetInnerHTML={{ __html: description }}
          />
        </div>
        {noButtons ? (
          ""
        ) : (
          <div className="flex gap-3">
            {page === "orderPage" ? (
              <>
                <WhiteButton
                  icon={"cloud-download.svg"}
                  text={"Ürünleri Dışarı Aktar"}
                />
                <WhiteButton icon={"cloud-upload.svg"} text={"CSV ile Yükle"} />
                <PurpleButton icon={"plus.svg"} text={"Sipariş Ekle"} />
              </>
            ) : (
              ""
            )}

            {page === "orderDetail" ? (
              <>
                <WhiteButton icon={false} text={"Siparişi İptal Et"} />
                <BlueButton icon={false} text={"Siparişi Onayla"} />
              </>
            ) : (
              ""
            )}
          </div>
        )}
      </div>

      <PageLinks pageLinks={pageLinks} />
    </div>
  );
}
