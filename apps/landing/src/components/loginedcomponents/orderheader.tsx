"use client";
import { IconUser } from "@tabler/icons-react";
import Image from "next/image";
import Link from "next/link";
import { useState } from "react";

import userDropdown from "../../../public/assets/dashboarUserBg.svg";

export default function Header() {
  const [drop, setDrop] = useState<boolean>(false);
  const [dropdomain, setDropDomain] = useState<boolean>(false);
  return (
    <header className="px-3 md:px-8 py-10 w-full flex justify-between bg-white relative h-[82px] border-b">
      <div className="flex items-center">
        <Link href="/">
          <Image
            src="/assets/logodark.svg"
            width={157}
            height={38}
            alt="logo"
            style={{
              maxWidth: "100%",
              height: "auto",
            }}
          />
        </Link>
      </div>
      <div className="items-center hidden px-2 lg:flex gap-x-5">
        <div
          onClick={() => setDropDomain(!dropdomain)}
          className="bg-[#DFEAFF] py-[10px] gap-x-1 rounded px-[16px] flex flex-row"
        >
          <span className="hidden text-[12px] sm:text-[14px] max-sm:max-w-[150px] truncate text-[#24262D] font-medium lg:block">
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
        </div>
        <div
          onClick={() => setDrop(!drop)}
          className="relative flex gap-x-1 md:gap-x-2"
        >
          <div className="rounded-[3.5px] text-[#565E73] text-[10px] border border-[#D7DAE0] p-[9px] font-medium block">
            <IconUser size={20} />
          </div>
          <button className=" max-md:hidden flex gap-x-[8px] items-center justify-center">
            <div className="text-[#1D2939]  text-[14px] font-medium">
              Sezer Toğantemür
            </div>
            <Image
              src={"/assets/chevron-down.svg"}
              width={20}
              height={20}
              alt=""
              className={`${drop ? "rotate-180" : ""} transition-all`}
              style={{
                maxWidth: "100%",
                height: "auto",
              }}
            />
          </button>
          {drop ? (
            <div className="grid grid-rows-2 absolute mt-[20px] right-0 top-4 min-w-[211px] max-h-[140px] min-h-fit py-5 pb-0">
              <Image
                src={userDropdown}
                width={211}
                height={157}
                alt=""
                className="absolute min-w-[211px] min-h-[139px] object-contain right-0 top-0"
              />
              <div
                className="flex flex-col gap-1 z-10 h-fit px-5"
              >
                <label className="text-[#1D2939] font-medium">Aslı Demir</label>
                <p className="text-xs font-medium text-[#565E73]">Müşteri Numarası: 90345661</p>
              </div>
              <Link
                className="z-10 h-fit py-[6px] px-5 border-b border-t mt-3 border-[#EDEEF1]"
                href="/"
              >
                <p className="text-sm text-[#667085]">Profil Ayarları</p>
              </Link>
              <Link
                className="z-10 h-fit px-5"
                href="/"
              >
                <p className="text-sm text-[#667085] pt-3">Çıkış Yap</p>
              </Link>
            </div>
          ) : (
            ""
          )}
        </div>
      </div>
    </header>
  );
}
