"use client";
import axios from "axios";
import { ErrorMessage, Field, Form, Formik } from "formik";
import Image from "next/image";
import Link from "next/link";
import * as Yup from "yup";

import { Politikalar } from "@/components/contact-us/politikalar";
import { Lcfooter } from "@/components/footer/lcfooter";
import { Header } from "@/components/header/header";

interface FormData {
  name: string;
  surname: string;
  phone: string;
  email: string;
  message: string;
  service: string[];
}
const initialValues: FormData = {
  name: "",
  surname: "",
  phone: "",
  email: "",
  message: "",
  service: [],
};
export default function İletisim() {
  const validationSchema = Yup.object().shape({
    name: Yup.string()
      .required("Ad zorunludur.")
      .min(3, "Ad zorunludur.")
      .max(40, "Ad  zorunludur."),
    surname: Yup.string()
      .required("Soyad zorunludur.")
      .min(3, "Soyad zorunludur.")
      .max(40, "Soyad  zorunludur."),
    phone: Yup.string()
      .required("Telefon zorunludur.")
      .matches(/^\d+$/, "Geçerli bir telefon numarası giriniz."),
    email: Yup.string()
      .required("E-posta zorunludur.")
      .test(
        "is-valid-email",
        "Geçerli bir e-posta adresi giriniz.",
        function (email) {
          const emailRegex = /^[\w%.-]+@[\d.A-Za-z-]+\.[A-Za-z]{2,4}$/;
          return emailRegex.test(email);
        }
      ),
    message: Yup.string()
      .required("Mesaj zorunludur.")
      .min(5, "5-500 karakter.")
      .max(500, "Mesaj en fazla 500 karakter içermelidir."),
  });
  // eslint-disable-next-line unicorn/consistent-function-scoping
  const onSubmit = async (values: FormData, actions: any) => {
    try {
      const response = await axios.post("", {
        data: {
          name: values.name,
          surname: values.surname,
          phone: values.phone,
          email: values.email,
          message: values.message,
          service: values.service.join(" , "),
        },
      });
      console.log("Form verileri başarıyla gönderildi:", response);
      actions.resetForm();
    } catch (error) {
      console.error("Form verileri gönderilirken bir hata oluştu:", error);
    }
  };
  return (
    <>
      <Header />
      <div className="flex w-full flex-col items-center bg-white">
        <div className="mt-6 flex flex-col justify-center xl:flex-row">
          <div className="flex max-w-[680px] flex-col  max-md:px-4">
            <h1 className="max-w-[604px] text-9xl font-bold text-[#101828]">
              Beraber çalışarak işinizi büyütelim
            </h1>
            <p className="py-5 text-3xl font-normal text-[#475467]">
              Bizimle iletişime geçin
            </p>
            <Formik
              initialValues={initialValues}
              validationSchema={validationSchema}
              onSubmit={onSubmit}
            >
              <Form className="flex w-full max-w-[549px] flex-col">
                <div className="mb-6 flex flex-col justify-between gap-3 sm:flex-row">
                  <div className="flex-1">
                    <label
                      htmlFor="name"
                      className=" text-lg font-medium text-[#344054] "
                    >
                      Ad
                    </label>
                    <Field
                      type="text"
                      id="name"
                      name="name"
                      className="mt-1 w-full rounded-lg border border-[#D0D5DD] px-[14px] py-[10px] shadow-[0px_1px_2px_0px_rgba(16,24,40,0.05)] focus:border-2 focus:border-[#D0D5DD] focus:outline-none"
                      placeholder="Ad"
                    />
                    <ErrorMessage
                      name="name"
                      component="div"
                      className="pt-[2px] text-[#344054]"
                    />
                  </div>
                  <div className="flex-1">
                    <label
                      htmlFor="surname"
                      className=" text-lg font-medium text-[#344054] "
                    >
                      Soyad
                    </label>
                    <Field
                      type="text"
                      id="surname"
                      name="surname"
                      className="mt-1 w-full rounded-lg border border-[#D0D5DD] px-[14px] py-[10px] shadow-[0px_1px_2px_0px_rgba(16,24,40,0.05)] focus:border-2 focus:border-[#D0D5DD] focus:outline-none"
                      placeholder="Soyad"
                    />
                    <ErrorMessage
                      name="surname"
                      component="div"
                      className="pt-[2px] text-[#344054]"
                    />
                  </div>
                </div>
                <div className="mb-6 w-full">
                  <label
                    htmlFor="email"
                    className=" text-lg font-medium text-[#344054] "
                  >
                    E-mail
                  </label>
                  <Field
                    type="email"
                    id="email"
                    name="email"
                    className="mt-1 w-full rounded-lg border border-[#D0D5DD] px-[14px] py-[10px] shadow-[0px_1px_2px_0px_rgba(16,24,40,0.05)] focus:border-2 focus:border-[#D0D5DD] focus:outline-none"
                    placeholder="E-mail"
                  />
                  <ErrorMessage
                    name="email"
                    component="div"
                    className="pt-[2px] text-[#344054]"
                  />
                </div>
                <div className="mb-6 w-full">
                  <label
                    htmlFor="phone"
                    className=" text-lg font-medium text-[#344054] "
                  >
                    Telefon
                  </label>
                  <Field
                    type="phone"
                    id="phone"
                    name="phone"
                    className="mt-1 w-full rounded-lg border border-[#D0D5DD] px-[14px] py-[10px] shadow-[0px_1px_2px_0px_rgba(16,24,40,0.05)] focus:border-2 focus:border-[#D0D5DD] focus:outline-none"
                    placeholder="Telefon"
                  />
                  <ErrorMessage
                    name="phone"
                    component="div"
                    className="pt-[2px] text-[#344054]"
                  />
                </div>
                <div className="mb-6 w-full">
                  <label
                    htmlFor="message"
                    className=" text-lg font-medium text-[#344054] "
                  >
                    Mesaj
                  </label>
                  <Field
                    as="textarea"
                    id="message"
                    rows={4}
                    name="message"
                    className="mt-1 w-full rounded-lg border border-[#D0D5DD] px-[14px] py-[10px] shadow-[0px_1px_2px_0px_rgba(16,24,40,0.05)] focus:border-2 focus:border-[#D0D5DD] focus:outline-none"
                    placeholder="Bize mesajınızı iletin."
                  />
                  <ErrorMessage
                    name="message"
                    component="div"
                    className="pt-[2px] text-[#344054]"
                  />
                </div>
                <h3 className=" pt-2 text-lg font-medium text-[#344054]">
                  Hizmetlerimiz
                </h3>
                <div className="grid grid-cols-2 tracking-tighter md:grid-cols-3">
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <Field
                      type="checkbox"
                      name="service"
                      value="Web Site Tasarımı"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Web Site Tasarımı
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <Field
                      type="checkbox"
                      name="service"
                      value="Pazaryeri Entegrasyonları"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Pazaryeri Entegrasyonları
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <Field
                      type="checkbox"
                      name="service"
                      value="Stok Yönetimi"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Stok Yönetimi
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <Field
                      type="checkbox"
                      name="service"
                      value="Web Site Kurulumu"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Web Site Kurulumu
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <Field
                      type="checkbox"
                      name="service"
                      value="Ödeme Seçenekleri"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Ödeme Seçenekleri
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <Field
                      type="checkbox"
                      name="service"
                      value="Kargo Entegrasyonları"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Kargo Entegrasyonları
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <Field
                      type="checkbox"
                      name="service"
                      value="E-ticaret Entegrasyonları"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    E-ticaret Entegrasyonları
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <Field
                      type="checkbox"
                      name="service"
                      value="Ürün Yönetimi"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Ürün Yönetimi
                  </label>
                  <label className="flex max-w-[170px] gap-1 break-words pt-6 text-[14px] font-normal text-[#344054]">
                    <Field
                      type="checkbox"
                      name="service"
                      value="Analitik ve Raporlama"
                      className="h-5 w-[20px]  rounded-lg  border-2 border-[#D0D5DD] accent-[#183ADD]"
                    />
                    Analitik ve Raporlama
                  </label>
                </div>
                <button
                  type="submit"
                  className="mt-8 flex h-[48px] max-w-[555px] items-center justify-center rounded-lg border border-[#7F56D9] bg-[#151E56] text-xl font-bold text-white hover:bg-[#0C1239] "
                >
                  Gönder
                </button>
              </Form>
            </Formik>
          </div>
          <div className="flex flex-col items-center bg-[url('/assets/iletisimbg.jpg')] bg-no-repeat max-xl:mt-14 max-lg:max-w-[638px] max-lg:px-4 lg:w-[638px] xl:ml-8 xl:mt-5">
            <Image
              src="/assets/iletisim.svg"
              width={358}
              height={252}
              alt="w3yz"
              className="pt-10"
            />
            <div className="flex flex-col items-center pt-20">
              <h1 className="text-[20px] font-semibold text-[#101828]">
                Destek
              </h1>
              <p className="pt-2 text-xl font-normal text-[#475467]">
                Size yardım etmek için buradayız
              </p>
              <Link
                href="mailto:support@w3yz.com"
                className=" pt-5 text-xl font-semibold text-[#6941c6]"
              >
                support@w3yz.com
              </Link>
            </div>
            <div className="flex flex-col items-center pt-10">
              <h1 className="text-[20px] font-semibold text-[#101828]">
                Satış
              </h1>
              <p className="pt-2 text-xl font-normal text-[#475467]">
                Sorularınız mı var? iletşime geçelim
              </p>
              <Link
                href="mailto:sales@w3yz.com"
                className="pt-5 text-xl font-semibold text-[#6941c6]"
              >
                sales@w3yz.com
              </Link>
            </div>
            <div className="flex flex-col items-center pt-10">
              <h1 className="text-[20px] font-semibold text-[#101828]">
                Telefon
              </h1>
              <p className="pt-2 text-xl font-normal text-[#475467]">
                Pazartesi - Cuma saat 08.00- 17.00
              </p>
              <Link
                href="tel:011248127"
                className=" mb-[70px] pt-5 text-xl font-semibold text-[#6941c6]"
              >
                0335252351
              </Link>
            </div>
          </div>
        </div>
        <Politikalar />
        <Lcfooter />
      </div>
    </>
  );
}
