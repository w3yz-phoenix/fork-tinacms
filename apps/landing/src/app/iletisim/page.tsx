"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import Image from "next/image";
import Link from "next/link";
import { useFormState } from "react-dom";
import { useForm } from "react-hook-form";
import { z } from "zod";

import { Politikalar } from "#landing/components/contact-us/politikalar";
import { Lcfooter } from "#landing/components/footer/lcfooter";
import { FormInput, FormTextArea } from "#landing/components/form-input";
import { Header } from "#landing/components/header/header";
import { SubmitButton } from "#landing/components/submit-button";

import { ContactSendSchema } from "./contact-schema";
import { sendContactEmailForm } from "./mail-action";

type ContactSendSchemaType = z.infer<typeof ContactSendSchema>;

export default function ContactPage() {
  const form = useForm<ContactSendSchemaType>({
    resolver: zodResolver(ContactSendSchema),
    mode: "all",
  });

  const { register, formState } = form;

  const [formSubmitState, formAction] = useFormState(
    sendContactEmailForm,
    undefined
  );
  console.log(formSubmitState?.message);

  return (
    <>
      <Header />
      <div className="flex w-full flex-col items-center bg-white px-4 lg:mx-0">
        <div className="mt-6 grid grid-cols-1 gap-8 xl:grid-cols-2 xl:flex-row xl:gap-10">
          <div className="flex max-w-[680px] flex-col">
            <h1 className="max-w-[604px] text-[48px] font-bold text-[#101828] max-sm:text-[32px]">
              Beraber çalışarak işinizi büyütelim
            </h1>
            <p className="py-5 text-3xl font-normal text-[#475467] max-sm:text-[16px]">
              Bizimle iletişime geçin
            </p>
            <form action={formAction}>
              <div className="mb-4 grid grid-cols-1 gap-4 md:grid-cols-2">
                <FormInput
                  {...register("firstName")}
                  label="Ad"
                  placeholder="Ad"
                  type="text"
                  key="name"
                  id="name"
                  error={formState.errors.firstName?.message}
                />
                <FormInput
                  {...register("lastName")}
                  label="Soyad"
                  type="text"
                  key="surname"
                  id="surname"
                  placeholder="Soyad"
                  error={formState.errors.lastName?.message}
                />
              </div>
              <div className="mb-4">
                <FormInput
                  {...register("email")}
                  label="E-Posta"
                  type="email"
                  key="email"
                  id="email"
                  placeholder="example@example.com"
                  error={formState.errors.email?.message}
                />
              </div>
              <div className="mb-4">
                <FormInput
                  {...register("phone")}
                  label="Telefon Numarası"
                  type="phone"
                  key="phoneNumber"
                  id="phoneNumber"
                  placeholder="0 5(__) ___ __ __"
                  error={formState.errors.phone?.message}
                />
              </div>
              <div className="mb-3">
                <FormTextArea
                  {...register("message")}
                  label="Mesaj"
                  error={formState.errors.message?.message}
                />
              </div>
              <div className="mb-3">
                <h3 className=" pt-2 text-lg font-medium text-[#344054]">
                  Hizmetlerimiz
                </h3>
                <div className="grid grid-cols-2 tracking-tighter md:grid-cols-3">
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <input
                      type="checkbox"
                      name="service"
                      value="Web Site Tasarımı"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Web Site Tasarımı
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <input
                      type="checkbox"
                      name="service"
                      value="Pazaryeri Entegrasyonları"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Pazaryeri Entegrasyonları
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <input
                      type="checkbox"
                      name="service"
                      value="Stok Yönetimi"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Stok Yönetimi
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <input
                      type="checkbox"
                      name="service"
                      value="Web Site Kurulumu"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Web Site Kurulumu
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <input
                      type="checkbox"
                      name="service"
                      value="Ödeme Seçenekleri"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Ödeme Seçenekleri
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <input
                      type="checkbox"
                      name="service"
                      value="Kargo Entegrasyonları"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Kargo Entegrasyonları
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <input
                      type="checkbox"
                      name="service"
                      value="E-ticaret Entegrasyonları"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    E-ticaret Entegrasyonları
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <input
                      type="checkbox"
                      name="service"
                      value="Ürün Yönetimi"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Ürün Yönetimi
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <input
                      type="checkbox"
                      name="service"
                      value="Analitik ve Raporlama"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Analitik ve Raporlama
                  </label>
                </div>
              </div>
              <SubmitButton
                disabled={!formState.isValid}
                className="inline-flex h-11 items-center justify-center rounded bg-[#292929] px-7 py-4 text-base font-medium leading-7 text-white shadow hover:bg-[#525252]"
              >
                Gönder
              </SubmitButton>
              <p className="mt-2 block text-[16px] text-[#222]">
                {formSubmitState?.message}
              </p>
            </form>
          </div>
          <div className="mt-10 w-full max-w-[638px] items-center gap-10 rounded-lg border border-[#D9D9D9] bg-gradient-to-b from-[#F6F2FF] via-[#f6f2ff5e] to-100% py-10 text-center xl:mb-10 xl:gap-0 xl:py-20">
            <div className="">
              <Image
                src="/assets/iletisim.svg"
                alt="contact-us-page"
                height={252}
                width={358}
                className="mx-auto"
              />
            </div>
            <div className="grid w-full grid-rows-3 gap-10">
              <div>
                <h1 className="text-[20px] font-semibold text-[#101828]">
                  Destek
                </h1>
                <p className="pt-2 text-xl text-[#475467]">
                  Size yardım etmek için buradayız
                </p>
                <Link
                  href="mailto:info@fruiceramics.com"
                  className=" pt-5 text-xl font-semibold text-[#6941C6]"
                >
                  support@w3yz.com
                </Link>
              </div>
              <div>
                <h1 className="text-[20px] font-semibold text-[#101828]">
                  Satış
                </h1>
                <p className="pt-2 text-xl  text-[#475467]">
                  Sorularınız mı var ? İletişime geçelim
                </p>
                <Link
                  href="mailto:info@fruiceramics.com"
                  className=" pt-5 text-xl font-semibold text-[#6941C6]"
                >
                  sales@w3yz.com
                </Link>
              </div>
              <div>
                <h1 className="text-[20px] font-semibold text-[#101828]">
                  Telefon
                </h1>
                <p className="pt-2 text-xl text-[#475467]">
                  Pazartesi - Cuma saat 09.00- 17.00
                </p>
                <Link
                  href="tel:05313803770"
                  className="pt-5 text-xl font-semibold text-[#6941C6]"
                >
                  0 (542) 834 64 64
                </Link>
              </div>
            </div>
          </div>
        </div>
        <Politikalar />
        <Lcfooter />
      </div>
    </>
  );
}
