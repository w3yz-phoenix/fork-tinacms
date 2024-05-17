"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";

export default function NewPassword() {
  const router = useRouter();
  const format = /[!"#$%&()*,.:<>?@^{|}]+/;

  const [password, setPassword] = useState<string>("");
  const [confirmPassword, setconfirmPassword] = useState<string>("");
  const [showPassword, setShowPassword] = useState<boolean>(false);
  const [requirementsMet, setRequirementsMet] = useState<number>(0);
  const [passwordsMatch, setPasswordsMatch] = useState<boolean>(false);

  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  // FIXME: Use zod here
  const passwordConditions = [
    {
      condition: password.length >= 8,
      color: "bg-[#72E3A3]",
    },
    {
      condition: /\d/.test(password),
      color: "bg-[#72E3A3]",
    },
    {
      condition: /[A-Z]/.test(password),
      color: "bg-[#72E3A3]",
    },
    {
      condition: /[!"#$%&()*,.:<>?@^{|}]+/.test(password),
      color: "bg-[#72E3A3]",
    },
  ];

  useEffect(() => {
    const metCount = passwordConditions.filter(
      (condition) => condition.condition
    ).length;
    setRequirementsMet(metCount);

    setPasswordsMatch(password === confirmPassword);
  }, [passwordConditions, password, confirmPassword]);

  const handleCodeSubmit = (event: any) => {
    event.preventDefault();
    router.push("/login");
  };

  return (
    <section className="w3yz-container flex h-[100vh] justify-between overflow-y-hidden bg-white">
      <div className="3xl:scale-100 flex w-full scale-75 items-center justify-center sm:scale-100 lg:w-1/2 lg:scale-[80%]">
        <div className="mx-2 w-[480px] text-center">
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
            Parola Oluştur
          </h1>
          <p className="mb-[32px]">
            Yeni parolanızı oluştururken aşağıdaki adımları izleyin.
          </p>
          <form>
            <div className="w-full">
              <label className="mb-[6px] block text-start text-[12px] font-medium text-[#24262D]">
                Yeni Parola
              </label>
              <div className="relative">
                <input
                  type={showPassword ? "text" : "password"}
                  placeholder="Parolayı Oluştur"
                  className="h-[50px] w-full rounded-[8px] border border-[#D7DAE0] px-4 outline-none focus:border-blue-500 focus:bg-white focus:outline-none"
                  value={password}
                  onChange={(event) => setPassword(event.target.value)}
                />
                {password.length > 0 && (
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
              <ul className="flex w-full gap-2 my-8">
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
                    password.length >= 8 ? "text-[#0A9150]" : "text-[#8A94A6]"
                  } w-1/2 text-[13px]`}
                >
                  <span>
                    {password.length >= 8 ? (
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
                    format.test(password) ? "text-[#0A9150]" : "text-[#8A94A6]"
                  } w-1/2 text-[13px]`}
                >
                  <span>
                    {format.test(password) ? (
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
                    /\d/.test(password) ? "text-[#0A9150]" : "text-[#8A94A6]"
                  } w-1/2 text-[13px]`}
                >
                  <span>
                    {/\d/.test(password) ? (
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
                    /[A-Z]/.test(password) ? "text-[#0A9150]" : "text-[#8A94A6]"
                  } w-1/2 text-[13px]`}
                >
                  <span>
                    {/[A-Z]/.test(password) ? (
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
            <div className="mb-[32px] w-full">
              <label
                className={`mb-[6px] block text-start text-[12px] font-medium ${
                  confirmPassword.length > 0 && !passwordsMatch
                    ? "text-[#B9291C]"
                    : "text-[#24262D]"
                }`}
              >
                Yeni Parolayı Doğrulayın
              </label>
              <div className="relative">
                <input
                  type={showPassword ? "text" : "password"}
                  placeholder="Yeni Parolayı Doğrulayın"
                  className={`h-[50px] w-full rounded-[8px] border px-4 outline-none focus:bg-white focus:outline-none${
                    confirmPassword.length > 0 && !passwordsMatch
                      ? "border-[#F87C71] focus:border-[#B9291C] "
                      : "border-[#D7DAE0] focus:border-blue-500 "
                  }`}
                  value={confirmPassword}
                  onChange={(event) => setconfirmPassword(event.target.value)}
                  disabled={requirementsMet != 4}
                />
                {password.length > 0 && (
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
              {confirmPassword.length > 0 && !passwordsMatch && (
                <p className="mt-1 text-start text-[14px] font-medium text-[#DC3526]">
                  Parolalar uyuşmuyor. Lütfen kontrol edin.
                </p>
              )}
            </div>
            <button
              type="submit"
              className={`mb-[20px] w-full rounded-lg border px-4 py-2 font-medium ${
                passwordsMatch && !(requirementsMet != 4)
                  ? "bg-[#3670FB] text-white"
                  : "cursor-not-allowed bg-[#DFEAFF] text-[#BDD5FF]"
              }`}
              onClick={handleCodeSubmit}
              disabled={!passwordsMatch && requirementsMet != 4}
            >
              Kaydet
            </button>
          </form>
        </div>
      </div>

      <div className="hidden w-1/2 flex-col justify-between bg-gradient-to-r from-[#F4C8C1] to-[#F8A3B6] pl-[5%] lg:flex">
        <div className="my-auto max-w-[656px] py-10 pr-10">
          <p className="mb-[24px] text-[1.5rem] font-medium leading-10 2xl:text-[2rem]">
            Ürün görsellerini hazırlarken, kolay bir şekilde arka plan
            oluşturarak zamandan tasarruf etmek senin elinde!
          </p>
          <p className="leading-6">
            Gelişmiş fotoğraf editörü sayesinde ürünlerinin arka planınını
            kolayca düzenleyebilirsin.
          </p>
        </div>
        <Image
          src="/assets/forgot-password.png"
          alt="W3yz Login"
          width={880}
          height={638}
          className="rounded-tl-lg "
        />
      </div>
    </section>
  );
}
