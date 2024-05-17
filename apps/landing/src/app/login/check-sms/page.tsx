"use client";

import VerificationCodeInput from "#landing/components/verify-code/verify-code";
import Image from "next/image";
import Link from "next/link";


export default function CheckSms() {
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
            Doğrulama Kodu
          </h1>
          <p className="mb-[32px]">
            SMS ile telefonunuza ilettiğimiz doğrulama kodunu girin.
          </p>
          <form>
            <VerificationCodeInput />
            {/* <Link href={`/login/check-sms`}>
              <button
                type="submit"
                className="border rounded-lg font-medium py-2 px-4 w-full mb-[20px] bg-[#3670FB] text-white"
              >
                Devam Et
              </button>
            </Link> */}
          </form>
          <div className="text-center">
            Doğrulama kodu gelmedi mi? &nbsp;
            <Link
              href={`/login/forgot-password`}
              className=" font-medium text-[#3670FB] hover:cursor-pointer"
            >
              Tekrar Gönder
            </Link>
          </div>
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
