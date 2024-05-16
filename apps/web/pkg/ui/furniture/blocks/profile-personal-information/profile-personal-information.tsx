"use client";

import { tinaField } from "tinacms/dist/react";
import { useState } from "react";

import type { TinaGraphql_PageBlocksProfilePersonalInformation } from "@w3yz/cms/api";

export const ProfilePersonalInformationBlock = ({
  block,
}: {
  block: TinaGraphql_PageBlocksProfilePersonalInformation;
}) => {
  const [gender, setGender] = useState<number | undefined>();
  return (
    <div
      className="min-h-[calc(100vh-495px)] lg:max-w-[872px] 2xl:mx-auto"
      data-tina-field={tinaField(block)}
    >
      <div className="mb-20 flex flex-col md:gap-0">
        <div>
          <div className="hidden md:block">
            <h2 className="mb-3 text-3xl font-semibold leading-[38px] text-[#101828]">
              {block.mainTitle}
            </h2>
            <p className="mb-4 text-base font-normal leading-normal text-[#656565] md:mb-8">
              {block.subTitle}
            </p>
          </div>

          <div className="mb-5 grid grid-cols-1 gap-5 md:grid-cols-2">
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                Ad
              </label>
              <div className="relative z-0 w-full">
                <input
                  className={
                    "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                  }
                  type={"text"}
                  placeholder={"Ad"}
                />
              </div>
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                Soyad
              </label>
              <div className="relative z-0 w-full">
                <input
                  className={
                    "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                  }
                  type={"text"}
                  placeholder={"Soyad"}
                />
              </div>
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                E-Mail
              </label>
              <div className="relative z-0 w-full">
                <input
                  className={
                    "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                  }
                  type={"email"}
                  placeholder={"E-Mail"}
                />
              </div>
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                Telefon Numarası
              </label>
              <div className="relative z-0 w-full">
                <input
                  className={
                    "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                  }
                  type={"text"}
                  placeholder={"Telefon Numarası"}
                />
              </div>
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                Doğum Tarihi
              </label>
              <div className="grid grid-cols-1 gap-5 sm:grid-cols-3">
                <div className="relative z-0 w-full">
                  <select
                    className={
                      "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                    }
                  >
                    <option value="">Gün</option>
                  </select>
                </div>
                <div className="relative z-0 w-full">
                  <select
                    className={
                      "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                    }
                  >
                    <option value="">Ay</option>
                  </select>
                </div>
                <div className="relative z-0 w-full">
                  <select
                    className={
                      "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                    }
                  >
                    <option value="">Yıl</option>
                  </select>
                </div>
              </div>
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                Cinsiyet
              </label>
              <div className="grid grid-cols-2 gap-5">
                <label
                  onClick={() => setGender(0)}
                  className={`${gender === 0 && "border-[#7C7C7C] bg-[#F6F6F6]"} relative z-0 w-full cursor-pointer select-none rounded-lg border border-gray-300 px-4 py-3 text-center text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200`}
                >
                  <input className={"hidden"} type={"radio"} name="gender" />
                  Kadın
                </label>
                <label
                  onClick={() => setGender(1)}
                  className={`${gender === 1 && "border-[#7C7C7C] bg-[#F6F6F6]"} relative z-0 w-full cursor-pointer select-none rounded-lg border border-gray-300 px-4 py-3 text-center text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200`}
                >
                  <input className={"hidden"} type={"radio"} name="gender" />
                  Erkek
                </label>
              </div>
            </div>
          </div>
        </div>
        <div className="mb-8 flex flex-col justify-end gap-5 text-nowrap text-base font-medium text-white md:flex-row">
          <button
            className={
              "h-11 w-full min-w-[200px] rounded bg-[#292929] px-4 py-[7px] text-white hover:bg-[#525252] disabled:bg-[#DCDCDC] md:max-w-fit"
            }
            type="submit"
          >
            Güncelle
          </button>
        </div>
      </div>
    </div>
  );
};
