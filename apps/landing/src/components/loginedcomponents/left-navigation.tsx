"use client";
import {
  IconLogout,
  IconMenu2,
  IconSettingsBolt,
  IconSettingsPlus,
  IconUser,
  IconX,
} from "@tabler/icons-react";
import Image from "next/image";
import Link from "next/link";
import { useState } from "react";

export default function LeftNavigation() {
  const [navigationLink, setNavigationLink] = useState<any>(0);
  const [discoverPlan, setDiscoverPlan] = useState<boolean>(true);
  const [mobileMenu, setMobileMenu] = useState<boolean>(false);
  const [copySuccess, setCopySuccess] = useState("");
  const [dropdomain, setDropDomain] = useState<boolean>(false);

  const handleCopy = () => {
    try {
      navigator.clipboard.writeText("123456");
      setCopySuccess("Copied!");
    } catch (err) {
      setCopySuccess("Failed to copy!");
    }
  };
  const handleClick = () => {
    setMobileMenu(!mobileMenu);
  };

  return (
    <div className="relative flex">
      <button
        type="button"
        onClick={handleClick}
        className={`${!mobileMenu && ""} lg:hidden absolute z-[100] w-7 h-7 bg-white right-5 -top-[57px]`}
      >
        {!mobileMenu ? (
          <IconMenu2 height={40} width={40} />
        ) : (
          <IconX height={40} width={40} />
        )}
      </button>
      <div
        className={`${mobileMenu && "right-0"} -right-full z-50 h-[calc(100vh-82px)] absolute lg:static flex bg-white flex-col justify-between gap-y-5 p-4 lg:border-r min-w-[271px] w-[272px] pt-4 transition-all duration-500 ease-in-out`}
      >
        <ul className="flex flex-col gap-y-1">
          <li className="flex flex-col justify-between w-full py-2 cursor-pointer lg:hidden">
            <p className="flex items-center text-[#24262D] text-[16px] font-medium gap-x-2">
              <IconUser height={20} width={20} />
              Sezer Toğantemür
            </p>
            <p className="text-[#565E73] font-light text-sm pl-8">
              <strong>Müşteri Numarası: </strong>{" "}
              <button type="button" onClick={handleCopy}>
                123456
              </button>
            </p>
          </li>
          <li>
            <Link
              href={"#"}
              className="flex items-center justify-between w-full py-2 cursor-pointer navigation"
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
              className="flex items-center justify-between w-full py-2 cursor-pointer navigation"
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
              className="flex items-center justify-between w-full py-2 cursor-pointer navigation"
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
              className="flex items-center justify-between w-full py-2 navigation"
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
              className="flex items-center justify-between w-full py-2 navigation"
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
              className="flex items-center justify-between w-full py-2 navigation"
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
              className="flex items-center justify-between w-full py-2 navigation"
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
              className="flex items-center justify-between w-full py-2 navigation"
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
              className="flex items-center justify-between w-full py-2 navigation"
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
          <li
            onClick={() => setDropDomain(!dropdomain)}
            className="bg-[#DFEAFF] py-[10px] gap-x-1 rounded px-[16px] flex flex-row justify-between lg:hidden"
          >
            <span className="text-[12px] sm:text-[14px] max-sm:max-w-[150px] truncate text-[#24262D] font-medium">
              shop2500.w3yz.com
            </span>
            <Image
              src={"/assets/chevron-down.svg"}
              width={20}
              height={20}
              alt=""
              className={`${dropdomain ? "rotate-180" : ""} transition-all`}
              style={{
                maxWidth: "100%",
                height: "auto",
              }}
            />
          </li>
        </ul>
        <div className="flex items-center justify-between w-full text-sm lg:hidden">
          <Link className="text-[#101828] flex items-center gap-1" href="/">
            <IconSettingsBolt height={16} width={16} />
            <span>Ayarlar</span>
          </Link>
          <Link className="text-[#101828] flex items-center gap-1" href="/">
            <IconLogout height={16} width={16} />
            <span>Çıkış Yap</span>
          </Link>
        </div>
      </div>
    </div>
  );
}
