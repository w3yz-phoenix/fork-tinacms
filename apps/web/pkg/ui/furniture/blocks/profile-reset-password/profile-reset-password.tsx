"use client";

import { tinaField } from "tinacms/dist/react";
import { useState } from "react";

import type { TinaGraphql_PageBlocksProfileResetPassword } from "@w3yz/cms/api";

import { ResetPasswordModal } from "./reset-password-modal";

export const ProfileResetPasswordBlock = ({
  block,
}: {
  block: TinaGraphql_PageBlocksProfileResetPassword;
}) => {
  const [resetPassModalShow, setResetPassModalShow] = useState<boolean>(false);
  return (
    <>
      <div
        className="min-h-[calc(100vh-495px)] lg:max-w-[600px] 2xl:mx-auto"
        data-tina-field={tinaField(block)}
      >
        <div className="mb-20 flex flex-col md:gap-0">
          <div>
            <div className="hidden md:block">
              <h2 className="mb-3 text-3xl font-semibold leading-[38px] text-[#101828]">
                {block.mainTitle}
              </h2>
              <p className="mb-4 text-base font-normal leading-normal text-[#656565] md:mb-8">
                Parolanızı Güncelleyin, güvenliğiniz için her 6 ayda bir yeni
                parola belirleyin.
              </p>
            </div>

            <div className="mb-5 grid gap-5">
              <div className="flex flex-col gap-1.5">
                <label className="text-[12px] font-medium text-[#292929]">
                  Mevcut Parola
                </label>
                <div className="relative z-0 w-full">
                  <input
                    className={
                      "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                    }
                    type={"password"}
                    placeholder={"Mevcut Parola"}
                  />
                </div>
              </div>
              <div className="flex flex-col gap-1.5">
                <label className="text-[12px] font-medium text-[#292929]">
                  Yeni Parola
                </label>
                <div className="relative z-0 w-full">
                  <input
                    className={
                      "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                    }
                    type={"password"}
                    placeholder={"Yeni Parola"}
                  />
                </div>
              </div>
              <div className="flex flex-col gap-1.5">
                <label className="text-[12px] font-medium text-[#292929]">
                  Yeni Parola(Tekrar)
                </label>
                <div className="relative z-0 w-full">
                  <input
                    className={
                      "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                    }
                    type={"password"}
                    placeholder={"Yeni Parola(Tekrar)"}
                  />
                </div>
              </div>
            </div>
          </div>
          <div className="mb-8 flex flex-col justify-between gap-5 text-nowrap text-base font-medium text-white md:flex-row">
            <button
              type="button"
              className="rounded bg-[#292929] px-7 py-[7px] font-medium text-white"
              onClick={() => setResetPassModalShow(!resetPassModalShow)}
            >
              Parolanızı mı unuttunuz?
            </button>
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
      <ResetPasswordModal
        isOpen={resetPassModalShow}
        setIsOpen={setResetPassModalShow}
      >
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
            <small className="mt-1 block text-[12px] text-[#989898]">
              Lütfen sisteme kayıtlı mail adresinizi girin.
            </small>
          </div>
        </div>
      </ResetPasswordModal>
    </>
  );
};
