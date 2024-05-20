"use client";

import Image from "next/image";
import Link from "next/link";
import { useState } from "react";

export default function LeftNavigation() {
  const [navigationLink, setNavigationLink] = useState<any>(0);
  const [discoverPlan, setDiscoverPlan] = useState<boolean>(true);
  const [mobileMenu, setMobileMenu] = useState<boolean>(false);

  const handleClick = () => {
    setMobileMenu(!mobileMenu);
  };

  return (
    <div className="relative flex">
      <div
        className={`${!mobileMenu && "-left-[272px]"} absolute lg:static flex bg-white flex-col justify-between gap-y-5 min-h-screen p-4 border-r min-w-[271px] w-[272px] pt-8`}
      >
        <button
          type="button"
          onClick={handleClick}
          className="lg:hidden absolute z-[100] w-7 h-7 bg-white border-y border-r -right-7 top-1.5 text-3xl flex justify-center items-center"
        >
          {!mobileMenu ? ">" : "<"}
        </button>
        <ul className="flex flex-col gap-y-2">
          <li>
            <Link
              href={"#"}
              className="flex items-center justify-between w-full px-3 py-2 cursor-pointer navigation"
            >
              <p className="flex items-center text-[#24262D] text-[16px] font-medium gap-x-2">
                <Image
                  src={"/assets/smart-home.svg"}
                  width={20}
                  height={20}
                  alt=""
                  style={{
                    maxWidth: "100%",
                    height: "auto",
                  }}
                />
                Kontrol Paneli
              </p>
              <div className="bg-[#3670FB] w-2 h-2 rounded-full"></div>
            </Link>
          </li>
          <li>
            <Link
              href={"#"}
              className="flex items-center justify-between w-full px-3 py-2 cursor-pointer navigation"
            >
              <p className="flex items-center text-[#24262D] text-[16px] font-medium gap-x-2">
                <Image
                  src={"/assets/siteeditoru.svg"}
                  width={20}
                  height={20}
                  alt=""
                  style={{
                    maxWidth: "100%",
                    height: "auto",
                  }}
                />
                Site Editörü
              </p>
            </Link>
          </li>
          <li>
            <Link
              href={"#"}
              className="flex items-center justify-between w-full px-3 py-2 cursor-pointer navigation"
            >
              <p className="flex items-center text-[#24262D] text-[16px] font-medium gap-x-2">
                <Image
                  src={"/assets/eticaret.svg"}
                  width={20}
                  height={20}
                  alt=""
                  style={{
                    maxWidth: "100%",
                    height: "auto",
                  }}
                />
                E- Ticaret
              </p>
            </Link>
          </li>
          <li>
            <Link
              href={"#"}
              className="flex items-center justify-between w-full px-3 py-2 navigation"
            >
              <p className="flex items-center text-[#ccccc4] text-[16px] font-medium gap-x-2">
                <Image
                  src={"/assets/analiz.svg"}
                  width={20}
                  height={20}
                  alt=""
                  style={{
                    maxWidth: "100%",
                    height: "auto",
                  }}
                  className=" opacity-20"
                />
                Analiz ve raporlar
              </p>
            </Link>
          </li>
          <li>
            <Link
              href={"#"}
              className="flex items-center justify-between w-full px-3 py-2 navigation"
            >
              <p className="flex items-center text-[#ccccc4] text-[16px] font-medium gap-x-2">
                <Image
                  src={"/assets/entegrasyonlar.svg"}
                  width={20}
                  height={20}
                  alt=""
                  style={{
                    maxWidth: "100%",
                    height: "auto",
                  }}
                  className=" opacity-20"
                />
                Entegrasyonlar
              </p>
            </Link>
          </li>
          <li>
            <Link
              href={"#"}
              className="flex items-center justify-between w-full px-3 py-2 navigation"
            >
              <p className="flex items-center text-[#ccccc4] text-[16px] font-medium gap-x-2">
                <Image
                  src={"/assets/domain.svg"}
                  width={20}
                  height={20}
                  alt=""
                  style={{
                    maxWidth: "100%",
                    height: "auto",
                  }}
                  className=" opacity-20"
                />
                Domain
              </p>
            </Link>
          </li>
          <li>
            <Link
              href={"#"}
              className="flex items-center justify-between w-full px-3 py-2 navigation"
            >
              <p className="flex items-center text-[#ccccc4] text-[16px] font-medium gap-x-2">
                <Image
                  src={"/assets/plan.svg"}
                  width={20}
                  height={20}
                  alt=""
                  style={{
                    maxWidth: "100%",
                    height: "auto",
                  }}
                  className=" opacity-20"
                />
                Plan
              </p>
            </Link>
          </li>
          <li>
            <Link
              href={"#"}
              className="flex items-center justify-between w-full px-3 py-2 navigation"
            >
              <p className="flex items-center text-[#ccccc4] text-[16px] font-medium gap-x-2">
                <Image
                  src={"/assets/yardim.svg"}
                  width={20}
                  height={20}
                  alt=""
                  style={{
                    maxWidth: "100%",
                    height: "auto",
                  }}
                  className=" opacity-20"
                />
                Yardım
              </p>
            </Link>
          </li>
          <li>
            <Link
              href={"#"}
              className="flex items-center justify-between w-full px-3 py-2 navigation"
            >
              <p className="flex items-center text-[#ccccc4] text-[16px] font-medium gap-x-2">
                <Image
                  src={"/assets/siteayarlari.svg"}
                  width={20}
                  height={20}
                  alt=""
                  style={{
                    maxWidth: "100%",
                    height: "auto",
                  }}
                  className=" opacity-20"
                />
                Site Ayarları
              </p>
            </Link>
          </li>
        </ul>
      </div>
    </div>
  );
}
