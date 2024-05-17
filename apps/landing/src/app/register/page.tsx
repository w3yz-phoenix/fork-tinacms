"use client";

import Image from "next/image";
import Link from "next/link";
import { useEffect, useState } from "react";
import axios from "axios";
import { useRouter } from "next/navigation";

interface RegisterFields {
  email: string;
  mobile: string;
  password: string;
  name: string;
  lname: string;
}

export default function Register() {
  const router = useRouter();
  const format = /[!"#$%&()*,.:<>?@^{|}]+/;

  const handleClearEmailInput = () => {
    setRegisterFields({
      ...registerFields,
      email: "",
    });
  };

  const handleClearPhoneInput = () => {
    setRegisterFields({
      ...registerFields,
      mobile: "",
    });
  };

  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  const [checked, setChecked] = useState<boolean>(false);
  const [buttonEnabled, setButtonEnabled] = useState<boolean>(false);
  const [requirementsMet, setRequirementsMet] = useState<number>(0);
  const [showPassword, setShowPassword] = useState<boolean>(false);
  const [registerFields, setRegisterFields] = useState<RegisterFields>({
    email: "",
    mobile: "",
    password: "",
    name: "",
    lname: "",
  });

  const passwordConditions = [
    {
      condition: registerFields.password.length >= 8,
      color: "bg-[#72E3A3]",
    },
    {
      condition: /\d/.test(registerFields.password),
      color: "bg-[#72E3A3]",
    },
    {
      condition: /[A-Z]/.test(registerFields.password),
      color: "bg-[#72E3A3]",
    },
    {
      condition: /[!"#$%&()*,.:<>?@^{|}]+/.test(registerFields.password),
      color: "bg-[#72E3A3]",
    },
  ];

  const formHandler = async (event: React.FormEvent) => {
    event.preventDefault();
    if (
      registerFields.password.length < 8 || // En az 8 karakter
      !/\d/.test(registerFields.password) || // En az bir sayı
      !/[A-Z]/.test(registerFields.password) || // En az bir büyük harf
      !/[!"#$%&()*,.:<>?@^{|}]+/.test(registerFields.password) // En az bir özel karakter
    ) {
      throw new Error("Şifre gereksinimlerini karşılamıyor.");
    }
    try {
      const response = await axios.post(
        "https://api.w3yzdev.com/api/register",
        registerFields
      );
      console.log("API Response:", response.data);
      if (response.data.error) {
        throw new Error(response.data.message);
      } else {
        console.log("Kayıt oluşturuldu.");
        router.push("/login");
      }
    } catch (error) {
      console.error("API Error:", error);
    }
  };

  useEffect(() => {
    const metCount = passwordConditions.filter(
      (condition) => condition.condition
    ).length;
    setRequirementsMet(metCount);
  }, [passwordConditions, registerFields.password]);

  useEffect(() => {
    if (
      checked &&
      passwordConditions.every((condition) => condition.condition) &&
      registerFields.email.length > 0 &&
      /^[\w%.-]+@[\d.A-Za-z-]+\.[A-Za-z]{2,4}$/.test(registerFields.email) &&
      /^\d+$/.test(registerFields.mobile) &&
      registerFields.mobile.length > 0 &&
      registerFields.mobile.length > 0 &&
      ((registerFields.mobile.startsWith("5") &&
        registerFields.mobile.length === 10) ||
        (registerFields.mobile.startsWith("0") &&
          registerFields.mobile.length === 11))
    ) {
      setButtonEnabled(true);
    } else {
      setButtonEnabled(false);
    }
  }, [checked, passwordConditions, registerFields]);

  return (
    <section className="w3yz-container flex h-[100vh] justify-between bg-white">
      <div className="3xl:scale-100 flex w-full scale-75 items-center justify-center sm:scale-100 lg:w-1/2 lg:scale-[80%]">
        <div className="w-[440px] text-center">
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
          <h1 className="mb-[24px] text-[28px] font-semibold">Kayıt Ol</h1>
          <p className="mb-[32px] text-[#464C5E]">
            W3YZ’ye hoşgeldiniz! lütfen bilgilerinizi girin.
          </p>
          <form
            onSubmit={(event) => formHandler(event)}
            className="flex w-full max-w-[440px] flex-col gap-y-4 text-start"
          >
            <div className="w-full">
              <label
                className={`mb-[6px]  block text-[12px] font-medium ${
                  registerFields.email.length > 0 &&
                  !/^[\w%.-]+@[\d.A-Za-z-]+\.[A-Za-z]{2,4}$/.test(
                    registerFields.email
                  )
                    ? "text-[#B9291C]"
                    : "text-[#24262D]"
                }`}
              >
                E-Posta
              </label>
              <div className="relative">
                <input
                  type="email"
                  placeholder="E-Posta"
                  className={`h-[50px] w-full rounded-[8px] border px-4 outline-none 
                  ${
                    registerFields.email.length > 0 &&
                    !/^[\w%.-]+@[\d.A-Za-z-]+\.[A-Za-z]{2,4}$/.test(
                      registerFields.email
                    )
                      ? "border-[#FCACA5] text-[#B9291C] focus:bg-white"
                      : "border-[#D7DAE0] focus:border-blue-500 focus:bg-white"
                  }`}
                  value={registerFields.email}
                  onKeyDown={(event) => {
                    if (event.key === "Enter") {
                      event.preventDefault();
                    }
                  }}
                  onChange={(event) => {
                    const emailValue = event.target.value;
                    const emailParts = emailValue.split("@");

                    setRegisterFields({
                      ...registerFields,
                      email: emailValue,
                      name: emailParts[0],
                      lname: emailParts[1],
                    });
                  }}
                />
                {registerFields.email.length > 0 && (
                  <button
                    onClick={handleClearEmailInput}
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
            <div className="w-full">
              <label
                className={`mb-[6px] block text-[12px] font-medium ${
                  registerFields.mobile.length > 0 &&
                  !(
                    /^\d+$/.test(registerFields.mobile) &&
                    ((registerFields.mobile.startsWith("5") &&
                      registerFields.mobile.length === 10) ||
                      (registerFields.mobile.startsWith("0") &&
                        registerFields.mobile.length === 11))
                  )
                    ? "text-[#B9291C]"
                    : "text-[#24262D]"
                }`}
              >
                Telefon
              </label>
              <div className="relative">
                <input
                  type="text"
                  placeholder="Telefon Numaran"
                  maxLength={registerFields.mobile.startsWith("5") ? 10 : 11}
                  className={`h-[50px] w-full rounded-[8px] border px-4 outline-none 
                ${
                  registerFields.mobile.length > 0 &&
                  !(
                    /^\d+$/.test(registerFields.mobile) &&
                    ((registerFields.mobile.startsWith("5") &&
                      registerFields.mobile.length === 10) ||
                      (registerFields.mobile.startsWith("0") &&
                        registerFields.mobile.length === 11))
                  )
                    ? "border-[#FCACA5] text-[#B9291C] focus:bg-white"
                    : "border-[#D7DAE0] focus:border-blue-500 focus:bg-white"
                }
                ${
                  registerFields.email.length > 0 &&
                  /^[\w%.-]+@[\d.A-Za-z-]+\.[A-Za-z]{2,4}$/.test(
                    registerFields.email
                  )
                    ? ""
                    : "bg-[#F6F7F9]"
                }`}
                  value={registerFields.mobile}
                  onKeyDown={(event) => {
                    if (event.key === "Enter") {
                      event.preventDefault();
                    }
                  }}
                  onChange={(event) =>
                    setRegisterFields({
                      ...registerFields,
                      mobile: event.target.value,
                    })
                  }
                  disabled={
                    !(
                      registerFields.email.length > 0 &&
                      /^[\w%.-]+@[\d.A-Za-z-]+\.[A-Za-z]{2,4}$/.test(
                        registerFields.email
                      )
                    )
                  }
                />
                {registerFields.mobile.length > 0 && (
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
            <div className="w-full">
              <label className="mb-[6px] block text-[12px] font-medium text-[#24262D]">
                Parola
              </label>
              <div className="relative">
                <input
                  type={showPassword ? "text" : "password"}
                  placeholder="Parolayı Oluştur"
                  className={`h-[50px] w-full rounded-[8px] border border-[#D7DAE0] px-4 outline-none focus:border-blue-500 focus:bg-white focus:outline-none${
                    /^\d+$/.test(registerFields.mobile) &&
                    ((registerFields.mobile.startsWith("5") &&
                      registerFields.mobile.length === 10) ||
                      (registerFields.mobile.startsWith("0") &&
                        registerFields.mobile.length === 11)) &&
                    registerFields.email.length > 0 &&
                    /^[\w%.-]+@[\d.A-Za-z-]+\.[A-Za-z]{2,4}$/.test(
                      registerFields.email
                    )
                      ? ""
                      : "bg-[#F6F7F9]"
                  }`}
                  value={registerFields.password}
                  onChange={(event) =>
                    setRegisterFields({
                      ...registerFields,
                      password: event.target.value,
                    })
                  }
                  disabled={
                    !(
                      /^\d+$/.test(registerFields.mobile) &&
                      ((registerFields.mobile.startsWith("5") &&
                        registerFields.mobile.length === 10) ||
                        (registerFields.mobile.startsWith("0") &&
                          registerFields.mobile.length === 11)) &&
                      registerFields.email.length > 0 &&
                      /^[\w%.-]+@[\d.A-Za-z-]+\.[A-Za-z]{2,4}$/.test(
                        registerFields.email
                      )
                    )
                  }
                />

                {registerFields.password.length > 0 && (
                  <span
                    onClick={togglePasswordVisibility}
                    className="absolute right-0 items-center pr-3 -translate-y-1/2 cursor-pointer top-1/2 before:flex"
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
                )}
              </div>
            </div>
            <div className="mb-8">
              <ul className="flex w-full gap-2 mb-4">
                {Array.from({ length: 4 }).map((_, index) => (
                  <li
                    key={index}
                    className={`h-[7px] w-full  rounded-[100px] ${
                      index < requirementsMet ? "bg-green-500" : "bg-gray-300"
                    }`}
                  ></li>
                ))}
              </ul>
              <ul className="flex flex-wrap gap-y-4">
                <li
                  className={`flex items-center gap-2 ${
                    registerFields.password.length >= 8
                      ? "text-[#0A9150]"
                      : "text-[#8A94A6]"
                  } w-1/2 text-[13px]`}
                >
                  <span>
                    {registerFields.password.length >= 8 ? (
                      <Image
                        src={"/assets/check.svg"}
                        width={1000}
                        height={600}
                        alt=""
                        className="object-cover w-full h-full"
                      />
                    ) : (
                      <Image
                        src={"/assets/x.svg"}
                        width={1000}
                        height={600}
                        alt=""
                        className="object-cover w-full h-full"
                      />
                    )}
                  </span>
                  Minimum 8 karkater olmalı
                </li>
                <li
                  className={`flex items-center gap-2 ${
                    format.test(registerFields.password)
                      ? "text-[#0A9150]"
                      : "text-[#8A94A6]"
                  } w-1/2 text-[13px]`}
                >
                  <span>
                    {format.test(registerFields.password) ? (
                      <Image
                        src={"/assets/check.svg"}
                        width={1000}
                        height={600}
                        alt=""
                        className="object-cover w-full h-full"
                      />
                    ) : (
                      <Image
                        src={"/assets/x.svg"}
                        width={1000}
                        height={600}
                        alt=""
                        className="object-cover w-full h-full"
                      />
                    )}
                  </span>
                  En az 1 özel karakter olmalı
                </li>
                <li
                  className={`flex items-center gap-2 ${
                    /\d/.test(registerFields.password)
                      ? "text-[#0A9150]"
                      : "text-[#8A94A6]"
                  } w-1/2 text-[13px]`}
                >
                  <span>
                    {/\d/.test(registerFields.password) ? (
                      <Image
                        src={"/assets/check.svg"}
                        width={1000}
                        height={600}
                        alt=""
                        className="object-cover w-full h-full"
                      />
                    ) : (
                      <Image
                        src={"/assets/x.svg"}
                        width={1000}
                        height={600}
                        alt=""
                        className="object-cover w-full h-full"
                      />
                    )}
                  </span>
                  En az 1 sayı İçermeli
                </li>
                <li
                  className={`flex items-center gap-2 ${
                    /[A-Z]/.test(registerFields.password)
                      ? "text-[#0A9150]"
                      : "text-[#8A94A6]"
                  } w-1/2 text-[13px]`}
                >
                  <span>
                    {/[A-Z]/.test(registerFields.password) ? (
                      <Image
                        src={"/assets/check.svg"}
                        width={1000}
                        height={600}
                        alt=""
                        className="object-cover w-full h-full"
                      />
                    ) : (
                      <Image
                        src={"/assets/x.svg"}
                        width={1000}
                        height={600}
                        alt=""
                        className="object-cover w-full h-full"
                      />
                    )}
                  </span>
                  En az 1 büyük harf içermeli
                </li>
              </ul>
            </div>

            <label className="relative inline-flex items-center cursor-pointer">
              <input
                type="checkbox"
                value=""
                className="sr-only peer"
                checked={checked}
                onChange={() => setChecked(!checked)}
              />
              <div
                className={`peer h-7 w-20 rounded-full border-2 after:absolute after:left-[4px] 
              after:top-[10px] after:h-5 after:w-5 after:rounded-full after:transition-all after:content-[''] peer-checked:after:translate-x-full 
              ${
                checked
                  ? "border-[#5C97FE] after:bg-[#1A31B3]"
                  : "border-[#B3B9C6] after:bg-[#565E73]"
              }`}
              ></div>
              <span className="ml-3 text-[14px] font-medium text-[#3D3D3D] dark:text-gray-300">
                W3yz İnternet Sitesinin Kullanım Koşulları’nı ve Gizlilik
                Politikası’nı okudum ve kabul ediyorum
              </span>
            </label>
            {registerFields.email.length > 0 &&
              !/^[\w%.-]+@[\d.A-Za-z-]+\.[A-Za-z]{2,4}$/.test(
                registerFields.email
              ) && (
                <div className="flex items-center rounded-md border border-[#FCACA5] bg-[#FEF3F2] px-4 py-2 text-start text-[#B9291C]">
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

            {registerFields.mobile.length > 1 &&
              !(
                /^\d+$/.test(registerFields.mobile) &&
                ((registerFields.mobile.startsWith("5") &&
                  registerFields.mobile.length === 10) ||
                  (registerFields.mobile.startsWith("0") &&
                    registerFields.mobile.length === 11))
              ) && (
                <div className="flex items-center rounded-md border border-[#FCACA5] bg-[#FEF3F2] px-4 py-2 text-start text-[#B9291C] ">
                  <span className="mr-4 rounded-full border-[3px] border-[#FCACA5] p-0.5">
                    <Image
                      src="/assets/alert-circle.svg"
                      alt="alert"
                      width={20}
                      height={20}
                    />
                  </span>
                  <div className="text-[14px] font-medium ">
                    <p>Geçersiz telefon numarası. Lütfen tekrar girin.</p>
                  </div>
                </div>
              )}
            <button
              type="submit"
              className={`h-[40px] w-full rounded-lg  text-[16px] font-medium text-white outline-none ${
                buttonEnabled
                  ? "pointer-events-auto bg-[#3670FB]"
                  : "pointer-events-none bg-[#DFEAFF]"
              }`}
              disabled={!buttonEnabled}
            >
              Kayıt Ol
            </button>

            <Link
              href={"#"}
              className="mb-8 flex h-[40px] w-full items-center justify-center gap-2 rounded-lg border border-[#D7DAE0] bg-white text-[16px] font-medium text-[#565E73]"
            >
              <Image
                src={"/assets/googleIcn.svg"}
                width={22}
                height={22}
                alt=""
              />
              Google ile Devam Et
            </Link>
          </form>
          <div className="text-center">
            {`Zaten bir hesabınız var mı? `}
            <Link
              href={`/login`}
              className=" font-medium text-[#3670FB] hover:cursor-pointer"
            >
              Giriş Yap
            </Link>
          </div>
        </div>
      </div>

      <div className="hidden w-1/2 flex-col justify-between bg-gradient-to-r from-[#D3E9F8] to-[#D0D9DF] pl-[5%] lg:flex">
        <div className="my-auto mr-10 max-w-[656px] pb-10">
          <p className="mb-[24px] pt-10 text-[1.5rem] font-medium leading-10 2xl:text-[2rem]">
            Şablonlarımız her ekrana uyumlu! Siteni kolayca mobil uyumlu hale
            getirebilirsin.
          </p>
          <p className="leading-6">
            Mobil uygulamamız sayesinde konum fark etmeden e-ticaret sitene
            ürünlerini kolayca ekleyebilir ve yönetebilirsin.
          </p>
        </div>
        <Image
          src="/assets/registerBg.png"
          alt="W3yz Login"
          width={880}
          height={638}
          className="rounded-tl-lg "
        />
      </div>
    </section>
  );
}
