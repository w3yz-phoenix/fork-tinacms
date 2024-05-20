import LoginedLaylout from "#landing/components/loginedcomponents/logined-layout";
import TopNavigation from "#landing/components/loginedcomponents/top-navigation";
import Image from "next/image";
import Link from "next/link";
import React, { useState } from "react";

export default function KontrolPaneli() {
  return (
    <LoginedLaylout>
      <section className="flex flex-col w-full h-full">
        <TopNavigation
          label={"Merhaba Sezer Togantemur"}
          description={"Kontrol panelinize tekrar hoş geldiniz"}
          noButtons
        />
        <div className="max-w-[1489px] mx-3 md:mx-auto border-[1px] rounded bg-white  border-[#D7DAE0] mt-[33px]">
          <div className="flex flex-wrap gap-8 p-4 flex-w lg:flex-row">
            <Image src="/assets/tema.png" width={569} height={304} alt="" />
            <div className="border-[1px] rounded  border-[#D7DAE0]">
              <div className="flex flex-col p-5">
                <div className="flex flex-row justify-between pb-4 border-b-[1px] border-[#EDEEF1] gap-x-6">
                  <p className="text-[16px] text-[#1D2939] font-semibold">
                    Site Adı
                  </p>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="20"
                    height="20"
                    fill="none"
                    viewBox="0 0 20 20"
                  >
                    <g
                      stroke="#8A94A6"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      clipPath="url(#clip0_1552_5142)"
                    >
                      <path d="M9.167 10a.833.833 0 101.667 0 .833.833 0 00-1.667 0zM9.167 15.833a.833.833 0 101.667 0 .833.833 0 00-1.667 0zM9.167 4.167a.833.833 0 101.666 0 .833.833 0 00-1.666 0z"></path>
                    </g>
                    <defs>
                      <clipPath id="clip0_1552_5142">
                        <path fill="#fff" d="M0 0H20V20H0z"></path>
                      </clipPath>
                    </defs>
                  </svg>
                </div>
                <div className="flex flex-row pt-8">
                  <p className="text-[#667085] text-[12px] font-normal">
                    Domain:
                  </p>
                  <Link
                    href="/"
                    className="text-[#1D2939] text-[12px] font-normal pl-1"
                  >
                    https://example.w3yz/my-site-3
                  </Link>
                </div>
                <Link href="/" className="flex flex-row pt-[5px]">
                  <p className="text-[#1163FA] text-[12px] font-normal">
                    Alan adı satın al veya ekle
                  </p>
                  <svg
                    className="pl-1"
                    xmlns="http://www.w3.org/2000/svg"
                    width="20"
                    height="20"
                    fill="none"
                    viewBox="0 0 20 20"
                  >
                    <g
                      stroke="#3670FB"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      clipPath="url(#clip0_1552_5155)"
                    >
                      <path d="M14.167 5.833l-8.334 8.334M6.667 5.833h7.5v7.5"></path>
                    </g>
                    <defs>
                      <clipPath id="clip0_1552_5155">
                        <path fill="#fff" d="M0 0H20V20H0z"></path>
                      </clipPath>
                    </defs>
                  </svg>
                </Link>
                <div className="flex flex-row pt-[5px]">
                  <p className="text-[#667085] text-[12px] font-normal">
                    Durum:
                  </p>
                  <p className="text-[#1163FA] text-[12px] font-normal pl-1">
                    Yayınlanmadı
                  </p>
                </div>
                <button className="md:w-[382px] md:h-[40px] max-md:p-3 flex justify-center items-center border-[1px] border-[#D7DAE0] text-[16px] text-[#565E73] font-medium bg-white mt-8 rounded-md">
                  Web Siteni Tarayıcıda Görüntüle
                </button>
                <button className="md:w-[382px] md:h-[40px] max-md:p-3 flex justify-center items-center border-[1px] border-[#D7DAE0] text-[16px] text-[#fff] font-medium bg-[#3670FB] mt-3 rounded-md">
                  Siteyi Düzenle
                </button>
              </div>
            </div>
            <Image src="/assets/plankullanimi.png" width={370} height={304} alt="" className="opacity-20" />
          </div>
        </div>
        <div className="mt-10 max-w-[1462px] max-h-[216px] m-3 md:mx-auto opacity-30">
          <Image src="/assets/plan.png" width={1489} height={1000} alt="" />
        </div>
      </section>
    </LoginedLaylout>
  );
}
