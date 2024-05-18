"use client";
import Image from "next/image";
import Link from "next/link";
import { useEffect, useState } from "react";

export function Header() {
  const [toggle, setToggle] = useState<boolean>(false);

  const handleToggle = () => {
    setToggle(!toggle);
  };

  useEffect(() => {
    document.body.style.overflow = toggle ? "hidden" : "auto";

    return () => {
      document.body.style.overflow = "auto";
    };
  }, [toggle]);
  return (
    <header className="sticky inset-x-0 top-0 z-50 bg-white">
      {/* First Header */}
      <div className="flex h-8 items-center justify-center bg-[#151E56] text-sm font-medium text-[#EDEEF1] sm:h-[50px]">
        E-Ticaret Siteniz için ideal Web Tasarım Çözümleri
      </div>
      {/* Second Header */}
      <div className="relative mx-auto flex h-14 max-w-[1400px] items-center justify-between px-4 font-medium sm:h-[88px] md:px-[24px] lg:px-[72px] 3xl:px-0">
        <div className="flex items-center text-[13px] md:text-[16px]">
          <Link href="/" className="pr-2.5">
            <Image
              src="./assets/w3yz-logo.svg"
              alt="logo"
              width={86}
              height={32}
            />
          </Link>
          <Link
            href="/coming-soon"
            className="hidden px-2 sm:block md:ml-5 md:px-6"
          >
            Çözümler
          </Link>
          <Link href="/blog" className="hidden px-2 sm:block md:px-6">
            Community
          </Link>
        </div>
        {/* Mobile */}
        <div className=" sm:hidden">
          <button onClick={handleToggle}>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="25"
              height="24"
              fill="none"
              viewBox="0 0 25 24"
            >
              <g
                stroke="#565E73"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                clipPath="url(#clip0_545_412)"
              >
                <path d="M4.92 8h16M4.92 16h16"></path>
              </g>
              <defs>
                <clipPath id="clip0_545_412">
                  <path
                    fill="#fff"
                    d="M0 0H24V24H0z"
                    transform="translate(.92)"
                  ></path>
                </clipPath>
              </defs>
            </svg>
          </button>
        </div>
        {toggle && (
          <div className="absolute inset-x-0 top-[56px]  z-50 flex h-[calc(100vh-88px)] w-full flex-col justify-between border-t border-[#EDEEF1] bg-white px-4 pb-[88px] pt-10 sm:hidden">
            <div className="flex flex-col gap-5 font-medium">
              <Link href="/coming-soon" className="px-2">
                Çözümler
              </Link>
              <Link href="/blog" className="px-2">
                Community
              </Link>
            </div>
            <div className="space-y-4">
              <Link href="/coming-soon">
                <button
                  type="button"
                  className="flex w-full items-center justify-center rounded-lg border border-DEFAULT px-3 py-2 font-medium text-[#565E73] hover:border-[#8A94A6] hover:bg-[#F6F6F6] hover:text-[#24262D] hover:shadow-[0px_0px_0px_2px_rgba(215,218,224,0.80)]"
                >
                  <span className="pl-2">Giriş Yap</span>
                </button>
              </Link>
              <Link
                href="https://fashion-studio.beta.w3yz.dev/admin#/~"
                target="_blank"
                className="flex items-center justify-center w-full px-3 py-2"
                id="header-button"
              >
                <button type="button">Sistemi İncele</button>
              </Link>
              {/* <button
                type="button"
                className="flex w-full items-center justify-center rounded-lg border border-DEFAULT px-3 py-2 font-medium text-[#565E73] hover:border-[#8A94A6] hover:bg-[#F6F6F6] hover:text-[#24262D] hover:shadow-[0px_0px_0px_2px_rgba(215,218,224,0.80)]"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="24"
                  height="24"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <g
                    stroke="#565E73"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth="2"
                    clipPath="url(#clip0_522_90)"
                  >
                    <path d="M3 12a9 9 0 1018.001 0A9 9 0 003 12zM3.6 9h16.8M3.6 15h16.8M11.5 3a17 17 0 000 18M12.5 3a17 17 0 010 18"></path>
                  </g>
                  <defs>
                    <clipPath id="clip0_522_90">
                      <path fill="#fff" d="M0 0H24V24H0z"></path>
                    </clipPath>
                  </defs>
                </svg>
                <span className="pl-2 ">Türkçe</span>
              </button> */}
            </div>
          </div>
        )}

        {/* Web */}
        <div className="hidden gap-5 text-[13px] sm:flex md:text-[18px]">
          {/* <button
            type="button"
            className="flex items-center justify-center rounded-lg border border-DEFAULT px-3 py-2 font-medium text-[#565E73] hover:border-[#8A94A6] hover:bg-[#F6F6F6] hover:text-[#24262D] hover:shadow-[0px_0px_0px_2px_rgba(215,218,224,0.80)]"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              fill="none"
              viewBox="0 0 24 24"
            >
              <g
                stroke="#565E73"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                clipPath="url(#clip0_522_90)"
              >
                <path d="M3 12a9 9 0 1018.001 0A9 9 0 003 12zM3.6 9h16.8M3.6 15h16.8M11.5 3a17 17 0 000 18M12.5 3a17 17 0 010 18"></path>
              </g>
              <defs>
                <clipPath id="clip0_522_90">
                  <path fill="#fff" d="M0 0H24V24H0z"></path>
                </clipPath>
              </defs>
            </svg>
            <span className="hidden pl-2 sm:block">Türkçe</span>
            <span className="pl-2 sm:hidden">TR</span>
          </button> */}
          <Link
            href="https://fashion-studio.beta.w3yz.dev/admin#/~"
            className="flex items-center justify-center px-3 py-1"
            target="_blank"
            id="header-button"
          >
            <button type="button">Sistemi İncele</button>
          </Link>
        </div>
      </div>
      {/* Third Header */}
      <div className="space-x-5 bg-[#F6F2FF] font-medium text-[#6B7280]">
        <ul className="mx-auto flex h-[42px] max-w-[1400px] items-center justify-between overflow-x-auto whitespace-nowrap px-1 text-lg md:px-[14px] lg:px-[62px] 3xl:px-0">
          <li className="px-3 hover:text-[#030711]">
            <Link href="/#w3yz-nedir">W3yz Nedir?</Link>
          </li>
          <li className="px-3 hover:text-[#030711]">
            <Link href="/#ozelliklerimiz">Özelliklerimiz</Link>
          </li>
          <li className="px-3 hover:text-[#030711]">
            <Link href="/#temalar">Temalar</Link>
          </li>
          <li className="px-3 hover:text-[#030711]">
            <Link href="/#community">Community</Link>
          </li>
          <li className="px-3 hover:text-[#030711]">
            <Link href="/coming-soon">App Market</Link>
          </li>
          <li className="px-3 hover:text-[#030711]">
            <Link href="/#fiyatlar">Fiyatlar</Link>
          </li>
          <li className="px-3 hover:text-[#030711]">
            <Link href="/#biz-kimiz">Biz Kimiz</Link>
          </li>
          <li className="px-3 hover:text-[#030711]">
            <Link href="/iletisim">İletişim</Link>
          </li>
          <li className="px-3 hover:text-[#030711]">
            <Link href="/#beraber-calisalim">Beraber Çalışalım</Link>
          </li>
        </ul>
      </div>
    </header>
  );
}
