"use client";
import { useState } from "react";
import Image from "next/image";
import Link from "next/link";

export default function ForgotPassword() {
  const [mobile, setMobile] = useState<string>("");
  const [isButtonDisabled, setIsButtonDisabled] = useState<boolean>(true);
  const [showError, setShowError] = useState<boolean>(false);

  const handleClearPhoneInput = (event: any) => {
    event.preventDefault();
    setMobile("");
    setShowError(false);
    setIsButtonDisabled(true);
  };

  const handleMobileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const newMobile = event.target.value;
    setMobile(newMobile);

    const isValidMobile = /^((5\d{9})|(0\d{10}))$/.test(newMobile);

    setIsButtonDisabled(!isValidMobile);
  };

  const handleBlur = () => {
    if (
      !(
        (mobile.startsWith("5") && mobile.length === 10) ||
        (mobile.startsWith("0") && mobile.length === 11)
      )
    ) {
      setShowError(true);
    }
  };

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    if (
      !(
        (mobile.startsWith("5") && mobile.length === 10) ||
        (mobile.startsWith("0") && mobile.length === 11)
      )
    ) {
      setShowError(true);
      return;
    }
  };

  return (
    <section className="w3yz-container flex h-[100vh] justify-between overflow-y-hidden bg-white">
      <div className="3xl:scale-100 flex w-full scale-75 items-center justify-center sm:scale-100 lg:w-1/2 lg:scale-[80%]">
        <div className="mx-2 w-[455px] text-center">
          <div className="flex flex-col items-center justify-center">
            <Link href={`/`}>
              <Image
                src="/assets/logodark.svg"
                alt="W3yz Logo"
                width={106}
                height={37}
                className="mb-[24px]"
              />
            </Link>
          </div>

          <h1 className="mb-[24px] text-[28px] font-semibold">
            Parola Yenileme
          </h1>
          <p className="mb-[32px]">
            Parolanızı yenileyebilmeniz için size bir kod göndereceğiz.
          </p>
          <form onSubmit={handleSubmit}>
            <div className="w-full mb-2 text-start">
              <label className="mb-[6px] block text-[12px] font-medium text-[#24262D]">
                Telefon
              </label>
              <div className="relative">
                <input
                  type="text"
                  name="mobile"
                  maxLength={mobile.startsWith("5") ? 10 : 11}
                  placeholder="Telefon Numaranızı Yazın"
                  className={`h-[50px] w-full rounded-[8px] border px-4 outline-none 
                ${
                  showError &&
                  !(
                    (mobile.startsWith("5") && mobile.length === 10) ||
                    (mobile.startsWith("0") && mobile.length === 11)
                  )
                    ? "border-[#F87C71] text-[#B9291C] focus:bg-white"
                    : "border-[#D7DAE0] focus:border-blue-500"
                }`}
                  value={mobile}
                  onKeyDown={(event) => {
                    if (event.key === "Enter") {
                      event.preventDefault();
                    }
                  }}
                  onChange={handleMobileChange}
                  onBlur={handleBlur}
                />
                {mobile.length > 0 && (
                  <button
                    onClick={handleClearPhoneInput}
                    className="absolute right-0 items-center pr-3 -translate-y-1/2 cursor-pointer top-1/2 before:flex"
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="20"
                      height="21"
                      viewBox="0 0 20 21"
                      fill="none"
                    >
                      <g clipPath="url(#clip0_328_285)">
                        <path
                          d="M15 5.08997L5 15.09"
                          stroke="#B3B9C6"
                          strokeWidth="1.25"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                        />
                        <path
                          d="M5 5.08997L15 15.09"
                          stroke="#B3B9C6"
                          strokeWidth="1.25"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                        />
                      </g>
                      <defs>
                        <clipPath id="clip0_328_285">
                          <rect
                            width="20"
                            height="20"
                            fill="white"
                            transform="translate(0 0.0899658)"
                          />
                        </clipPath>
                      </defs>
                    </svg>
                  </button>
                )}
              </div>
            </div>
            {showError &&
              !(
                (mobile.startsWith("5") && mobile.length === 10) ||
                (mobile.startsWith("0") && mobile.length === 11)
              ) && (
                <div className="flex items-center text-start text-[14px] font-medium text-[#B9291C] ">
                  <p>Lütfen geçerli bir telefon numarası girin.</p>
                </div>
              )}
            <Link href={`/login/check-sms`}>
              <button
                data-testid="handleLoginid"
                type="submit"
                className={`mb-[20px] mt-[32px] w-full rounded-lg border bg-[#3670FB] px-4 py-2 font-medium text-white ${
                  isButtonDisabled ? "cursor-not-allowed opacity-50" : ""
                }`}
                disabled={isButtonDisabled}
              >
                Kod Gönder
              </button>
            </Link>
          </form>
          <div className="text-center">
            <Link
              href={`/login`}
              className=" font-medium text-[#3670FB] hover:cursor-pointer"
            >
              Geri Dön
            </Link>
          </div>
        </div>
      </div>

      <div className="hidden w-1/2 flex-col justify-between bg-gradient-to-r from-[#f1dad1] to-[#f9b09d] pl-[5%] lg:flex">
        <div className="my-auto max-w-[656px] py-10 pr-10">
          <p className="mb-[24px] text-[1.5rem] font-medium leading-10 2xl:text-[2rem]">
            Profesyonel web siteni oluşturmak ve şık tasarımınla etki alanını
            genişletmek istiyorsan doğru yerdesin.
          </p>
          <p className="leading-6">
            Modern şablonlar arasından işine uygun bir şablon seç ve dilediğin
            gibi özelleştir.
          </p>
        </div>
        <Image
          src="/assets/login.png"
          alt="W3yz Login"
          width={880}
          height={638}
          className="rounded-tl-lg "
        />
      </div>
    </section>
  );
}
