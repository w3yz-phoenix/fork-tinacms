"use client";

import { useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import axios from "axios";
import { useRouter } from "next/navigation";
import Checkbx from "#landing/components/checkbx/checkbx";

interface loginFields {
  email: string;
  password: string;
}

const Login = () => {
  const router = useRouter();

  const [showPassword, setShowPassword] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string | undefined>(
    undefined
  );

  const [loginFields, setLoginFields] = useState<loginFields>({
    email: "",
    password: "",
  });

  const [isEmailValid, setIsEmailValid] = useState<boolean>(true);

  useEffect(() => {
    const isValid = /^[\w%+.-]+@[\d.A-Za-z-]+\.[A-Za-z]{2,4}$/.test(
      loginFields.email
    );
    setIsEmailValid(isValid);
  }, [loginFields.email]);

  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  const handleClearEmailInput = (event: React.MouseEvent) => {
    event.preventDefault();
    setLoginFields({
      ...loginFields,
      email: "",
    });
  };

  const handleLogin = async (event: React.FormEvent) => {
    event.preventDefault();

    try {
      const response = await axios.post(
        "https://api.w3yzdev.com/api/login",
        loginFields
      );
      console.log("API Response:", response.data);
      if (response.data.error) {
        throw new Error(response.data.message);
      } else {
        console.log("Giriş yapıldı.");
        router.push("/");
      }
    } catch (error) {
      console.error("API Error:", error);
      setErrorMessage(" ");
    }
  };

  useEffect(() => {
    setErrorMessage(undefined);
  }, [loginFields.email, loginFields.password]);

  return (
    <section className="w3yz-container flex h-[100vh] justify-between overflow-y-hidden bg-white">
      <div className="3xl:scale-100 flex w-full scale-75 items-center justify-center sm:scale-100 lg:w-1/2 lg:scale-[80%]">
        <div className="mx-2 w-[400px] text-center">
          <div className="flex flex-col items-center justify-center">
            <Image
              src="/assets/logodark.svg"
              alt="W3yz Logo"
              width={106}
              height={37}
              className="mb-[24px]"
            />
          </div>

          <h1 className="mb-[24px] text-[28px] font-semibold">Giriş Yap</h1>
          <p className="mb-[32px]">
            Tekrar hoşgeldiniz! Lütfen bilgilerinizi girin.
          </p>
          <form onSubmit={(event) => handleLogin(event)}>
            <div className="relative flex flex-col">
              <label
                className={`mb-[6px] text-start text-[12px] font-medium leading-4 ${
                  errorMessage ? "text-[#B9291C]" : "text-[#24262D]"
                } ${
                  loginFields.email.length > 0 && !isEmailValid
                    ? "text-[#B9291C]"
                    : "text-[#24262D]"
                }`}
              >
                E-Posta
              </label>
              <input
                type="email"
                placeholder="E-posta"
                className={`mb-4 rounded-lg border px-4 py-[13px] leading-6 outline-none  ${
                  errorMessage ||
                  (loginFields.email.length > 0 && !isEmailValid)
                    ? "border-[#FCACA5] text-[#B9291C] focus:border-[#FCACA5] focus:bg-white"
                    : "border-[#D7DAE0] text-[#667085] focus:border-blue-500 "
                }`}
                value={loginFields.email}
                onKeyDown={(event) => {
                  if (event.key === "Enter") {
                    event.preventDefault();
                  }
                }}
                onChange={(event) =>
                  setLoginFields({ ...loginFields, email: event.target.value })
                }
              />
              {loginFields.email.length > 0 && (
                <button
                  onClick={handleClearEmailInput}
                  className="absolute bottom-[30px] right-0 px-3 "
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
            <div className="relative flex flex-col">
              <label
                className={`mb-[6px] text-start text-[12px] font-medium leading-4 text-[#24262D] ${
                  errorMessage ? "text-[#B9291C]" : "text-[#24262D]"
                }`}
              >
                Parola
              </label>
              <input
                type={showPassword ? "text" : "password"}
                placeholder="Parola"
                className={`mb-4 rounded-lg border px-4 py-[13px] leading-6 focus:outline-none ${
                  errorMessage
                    ? "border-[#FCACA5] text-[#B9291C] focus:border-[#FCACA5] focus:bg-white"
                    : "border-[#D7DAE0] text-[#667085] focus:border-blue-500 "
                }`}
                value={loginFields.password}
                onChange={(event) =>
                  setLoginFields({
                    ...loginFields,
                    password: event.target.value,
                  })
                }
              />
              <span
                onClick={togglePasswordVisibility}
                className="absolute bottom-[30px] right-0 px-3 text-xl"
              >
                {showPassword ? (
                  <Image
                    src="/assets/closeye.svg"
                    alt="W3yz Logo"
                    width={20}
                    height={20}
                  />
                ) : (
                  <Image
                    src="/assets/openeye.svg"
                    alt="W3yz Logo"
                    width={20}
                    height={20}
                  />
                )}
              </span>
            </div>
            <div className="flex justify-between py-5 text-sm">
              <Checkbx label="Beni Hatırla" />
              <Link
                href={`/login/forgot-password`}
                className=" font-medium text-[#1A31B3] hover:cursor-pointer"
              >
                Parolamı Unuttum
              </Link>
            </div>
            {errorMessage && (
              <div className="mb-[32px] flex items-center rounded-md border border-[#FCACA5] bg-[#FEF3F2] p-4 text-start text-[#B9291C]">
                <span className="mr-4 rounded-full border-[3px] border-[#FCACA5] p-0.5">
                  <Image
                    src="/assets/alert-circle.svg"
                    alt="alert"
                    width={20}
                    height={20}
                  />
                </span>
                <div className="text-[14px] font-medium ">
                  <p>E-postanız veya parolanız hatalıdır.</p>
                  <p>Lütfen tekrar girin. </p>
                </div>
              </div>
            )}
            {!isEmailValid && loginFields.email.length > 0 && (
              <div className="mb-[32px] flex items-center rounded-md border border-[#FCACA5] bg-[#FEF3F2] px-4 py-2 text-start text-[#B9291C]">
                <span className="mr-4 rounded-full border-[3px] border-[#FCACA5] p-0.5">
                  <Image
                    src="/assets/alert-circle.svg"
                    alt="alert"
                    width={20}
                    height={20}
                  />
                </span>
                <div className="text-[14px] font-medium ">
                  <p>Geçersiz e-posta adresi. Lütfen tekrar girin.</p>
                </div>
              </div>
            )}

            <button
              data-testid="handleLoginid"
              type="submit"
              className="mb-[20px] w-full rounded-lg border bg-[#3670FB] px-4 py-2 font-medium text-white"
            >
              Giriş Yap
            </button>
            <button
              className="mb-[32px] flex w-full items-center justify-center space-x-3 rounded-lg border px-4 py-2 text-center font-bold"
              type="submit"
            >
              <Image
                src="/assets/icon-google.svg"
                alt="W3yz Logo"
                width={22}
                height={22}
              />
              <p className=" font-medium text-[#565E73]">
                Google ile Giriş Yap
              </p>
            </button>
          </form>
          <div className="text-center">
            {`Hesabınız yok mu ? `}
            <Link
              href={`/register`}
              className=" font-medium text-[#3670FB] hover:cursor-pointer"
            >
              Hesap Oluştur
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
};

export default Login;
