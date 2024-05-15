"use client";

import { tinaField } from "tinacms/dist/react";
import { useState } from "react";

import type { TinaGraphql_PageBlocksProfileAddress } from "@w3yz/cms/api";

import { AddressModal } from "./address-modal";

export const ProfileAddressBlock = ({
  block,
}: {
  block: TinaGraphql_PageBlocksProfileAddress;
}) => {
  const [modalShow, setModalShow] = useState<boolean>(false);
  return (
    <>
      <div
        className="min-h-[calc(100vh-495px)] xl:w-[881px]"
        data-tina-field={tinaField(block)}
      >
        <div className="mb-20 flex flex-col items-center justify-between gap-6 md:flex-row">
          <div className="flex flex-col-reverse gap-[52px] md:flex-col md:gap-0">
            <div>
              <h2 className="mb-3 text-3xl font-semibold leading-[38px] text-[#101828]">
                {block.mainTitle}
              </h2>
              <p className="text-base font-normal leading-normal text-[#656565]">
                Yeni adres oluşturun veya düzenleyin.
              </p>
            </div>
          </div>
          <button
            type="submit"
            className="flex h-11 max-w-fit items-center justify-center gap-3 rounded bg-[#292929] px-7 text-white hover:bg-[#525252] md:max-w-fit"
            onClick={() => setModalShow(true)}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="25"
              height="24"
              viewBox="0 0 25 24"
              fill="none"
            >
              <g clip-path="url(#clip0_3883_6350)">
                <path
                  d="M12.5 5V19"
                  stroke="white"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
                <path
                  d="M5.5 12H19.5"
                  stroke="white"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </g>
              <defs>
                <clipPath id="clip0_3883_6350">
                  <rect
                    width="24"
                    height="24"
                    fill="white"
                    transform="translate(0.5)"
                  />
                </clipPath>
              </defs>
            </svg>
            Adres Ekle
          </button>
        </div>

        <div className="grid grid-cols-1 gap-10 md:grid-cols-2">
          <div>
            <label className="mb-2 block text-[15px] font-medium text-[#344054]">
              Ev
            </label>
            <div className="rounded border border-[#D0D5DD] bg-white p-5">
              <label className="mb-3 block text-[16px] font-medium text-[#667085]">
                Şeyda Aydoğdu
              </label>
              <div className="flex flex-col gap-[16px]">
                <p className="text-[14px] text-[#667085]">
                  Atakent mahallesi 430 sokak no/1 daire 501
                </p>
                <p className="text-[14px] text-[#667085]">İdil/Şırnak</p>
                <p className="text-[14px] text-[#667085]">535*****67</p>
              </div>

              <div className="mt-6 flex gap-3">
                <button
                  type="submit"
                  className="flex h-11 w-full items-center justify-center gap-3 rounded bg-[#292929] px-7 text-white hover:bg-[#525252]"
                >
                  Güncelle
                </button>
                <button
                  type="submit"
                  className="flex h-11 w-full items-center justify-center gap-3 rounded border border-[#BDBDBD] bg-[#FFF] px-7 text-[#464646]"
                >
                  Sil
                </button>
              </div>
            </div>
          </div>
          <div>
            <label className="mb-2 block text-[15px] font-medium text-[#344054]">
              Ev
            </label>
            <div className="rounded border border-[#D0D5DD] bg-white p-5">
              <label className="mb-3 block text-[16px] font-medium text-[#667085]">
                Şeyda Aydoğdu
              </label>
              <div className="flex flex-col gap-[16px]">
                <p className="text-[14px] text-[#667085]">
                  Atakent mahallesi 430 sokak no/1 daire 501
                </p>
                <p className="text-[14px] text-[#667085]">İdil/Şırnak</p>
                <p className="text-[14px] text-[#667085]">535*****67</p>
              </div>

              <div className="mt-6 flex gap-3">
                <button
                  type="submit"
                  className="flex h-11 w-full items-center justify-center gap-3 rounded bg-[#292929] px-7 text-white hover:bg-[#525252]"
                >
                  Güncelle
                </button>
                <button
                  type="submit"
                  className="flex h-11 w-full items-center justify-center gap-3 rounded border border-[#BDBDBD] bg-[#FFF] px-7 text-[#464646]"
                >
                  Sil
                </button>
              </div>
            </div>
          </div>
          <div>
            <label className="mb-2 block text-[15px] font-medium text-[#344054]">
              Ev
            </label>
            <div className="rounded border border-[#D0D5DD] bg-white p-5">
              <label className="mb-3 block text-[16px] font-medium text-[#667085]">
                Şeyda Aydoğdu
              </label>
              <div className="flex flex-col gap-[16px]">
                <p className="text-[14px] text-[#667085]">
                  Atakent mahallesi 430 sokak no/1 daire 501
                </p>
                <p className="text-[14px] text-[#667085]">İdil/Şırnak</p>
                <p className="text-[14px] text-[#667085]">535*****67</p>
              </div>

              <div className="mt-6 flex gap-3">
                <button
                  type="submit"
                  className="flex h-11 w-full items-center justify-center gap-3 rounded bg-[#292929] px-7 text-white hover:bg-[#525252]"
                >
                  Güncelle
                </button>
                <button
                  type="submit"
                  className="flex h-11 w-full items-center justify-center gap-3 rounded border border-[#BDBDBD] bg-[#FFF] px-7 text-[#464646]"
                >
                  Sil
                </button>
              </div>
            </div>
          </div>
          <div>
            <label className="mb-2 block text-[15px] font-medium text-[#344054]">
              Ev
            </label>
            <div className="rounded border border-[#D0D5DD] bg-white p-5">
              <label className="mb-3 block text-[16px] font-medium text-[#667085]">
                Şeyda Aydoğdu
              </label>
              <div className="flex flex-col gap-[16px]">
                <p className="text-[14px] text-[#667085]">
                  Atakent mahallesi 430 sokak no/1 daire 501
                </p>
                <p className="text-[14px] text-[#667085]">İdil/Şırnak</p>
                <p className="text-[14px] text-[#667085]">535*****67</p>
              </div>

              <div className="mt-6 flex gap-3">
                <button
                  type="submit"
                  className="flex h-11 w-full items-center justify-center gap-3 rounded bg-[#292929] px-7 text-white hover:bg-[#525252]"
                >
                  Güncelle
                </button>
                <button
                  type="submit"
                  className="flex h-11 w-full items-center justify-center gap-3 rounded border border-[#BDBDBD] bg-[#FFF] px-7 text-[#464646]"
                >
                  Sil
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <AddressModal modalShow={modalShow} setModalShow={setModalShow} />
    </>
  );
};
