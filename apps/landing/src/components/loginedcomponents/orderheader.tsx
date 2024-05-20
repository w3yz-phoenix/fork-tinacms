"use client";
import Image from "next/image";
import Link from "next/link";
import { useState } from "react";

export default function Header() {
  const [drop, setDrop] = useState<boolean>(false);
  const [dropdomain, setDropDomain] = useState<boolean>(false);
  return (
    <header className="px-1 md:px-8 py-10 w-full flex justify-between bg-white relative h-[82px] border-b">
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
      <div className="flex items-center px-2 gap-x-5">
        <div
          onClick={() => setDropDomain(!dropdomain)}
          className="bg-[#DFEAFF] py-[10px] gap-x-1 rounded px-[16px] flex flex-row"
        >
          <span className=" text-[12px] sm:text-[14px] max-sm:max-w-[150px] truncate text-[#24262D] font-medium block">
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
        <div onClick={() => setDrop(!drop)} className="relative flex gap-x-1 md:gap-x-2">
          <div className="rounded-[3.5px] text-[#565E73] text-[10px] border border-[#D7DAE0] p-[9px] font-medium block">
            <Image src="/assets/user.svg" alt="" width={20} height={20} />
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
            <div className="grid grid-rows-2 absolute pl-[10px] pr-[40px] border mt-[20px] bg-[#fff] right-0 top-4">
              <Link
                className="text-[#101828] text-start  pt-[8px] pl-[5px] py-[5px] text-[12px] flex flex-row "
                href="/"
              >
                <Image
                  className="pr-[5px]"
                  src="/assets/settingslogo.svg"
                  width={20}
                  height={20}
                  alt=""
                  style={{
                    maxWidth: "100%",
                    height: "auto",
                  }}
                />
                Ayarlar
              </Link>
              <Link
                className="text-[#101828] text-[12px] pl-[5px] pt-[4px] pb-[7px] flex flex-row "
                href="/"
              >
                <Image
                  className="pr-[5px]"
                  src="/assets/singout.svg"
                  width={20}
                  height={20}
                  alt=""
                  style={{
                    maxWidth: "100%",
                    height: "auto",
                  }}
                />
                Çıkış Yap
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
