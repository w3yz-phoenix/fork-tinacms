"use client";

import Image from "next/image";
import { useState } from "react";

import template1 from "../../../public/assets/temp1.png";
import template2 from "../../../public/assets/template2.png";
import template3 from "../../../public/assets/template3.png";
import template4 from "../../../public/assets/template4.png";
import template5 from "../../../public/assets/template5.png";
import template6 from "../../../public/assets/template6.png";
import template7 from "../../../public/assets/template7.png";
import template8 from "../../../public/assets/template8.png";

import { TemplateModal } from "./templates-modal";

export function Templates() {
  const [modalContent, setModalContent] = useState<string>("");
  const [isShow, setIsShow] = useState<boolean>(false);

  const templateModal = (content: string) => {
    setModalContent(content);
    setIsShow(true);
  };
  return (
    <section
      className="container relative mx-auto my-[180px] px-5"
      id="temalar"
    >
      <div className="mx-auto mb-20 flex max-w-[1016px] flex-col gap-4 text-center font-medium text-[#030711]">
        <span className="text-[14px]">Temalar</span>
        <label className="text-[64px]">İşinize Uygun Temaları Keşfedin</label>
        <p className="text-[22px]">
          İşinize uygun temayı seçerek istediğiniz gibi özelleştirebilirsiniz.
        </p>
      </div>

      <div className="grid grid-cols-2 gap-6 lg:grid-cols-4">
        <div
          className="cursor-pointer overflow-hidden rounded-xl border border-[#EDE8FF] transition-all hover:border-[#D0C3FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF]"
          onClick={() => templateModal("frame1")}
        >
          <Image
            src={template1}
            width={322}
            height={501}
            alt=""
            className="size-full"
          />
        </div>
        <div
          className="cursor-pointer overflow-hidden rounded-xl border border-[#EDE8FF] transition-all hover:border-[#D0C3FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF]"
          onClick={() => templateModal("frame1")}
        >
          <Image
            src={template2}
            width={322}
            height={501}
            alt=""
            className="size-full"
          />
        </div>
        <div
          className="cursor-pointer overflow-hidden rounded-xl border border-[#EDE8FF] transition-all hover:border-[#D0C3FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF]"
          onClick={() => templateModal("frame1")}
        >
          <Image
            src={template3}
            width={322}
            height={501}
            alt=""
            className="size-full"
          />
        </div>
        <div
          className="cursor-pointer overflow-hidden rounded-xl border border-[#EDE8FF] transition-all hover:border-[#D0C3FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF]"
          onClick={() => templateModal("frame1")}
        >
          <Image
            src={template4}
            width={322}
            height={501}
            alt=""
            className="size-full"
          />
        </div>
        <div
          className="cursor-pointer overflow-hidden rounded-xl border border-[#EDE8FF] transition-all hover:border-[#D0C3FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF]"
          onClick={() => templateModal("frame1")}
        >
          <Image
            src={template5}
            width={322}
            height={501}
            alt=""
            className="size-full"
          />
        </div>
        <div
          className="cursor-pointer overflow-hidden rounded-xl border border-[#EDE8FF] transition-all hover:border-[#D0C3FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF]"
          onClick={() => templateModal("frame1")}
        >
          <Image
            src={template6}
            width={322}
            height={501}
            alt=""
            className="size-full"
          />
        </div>
        <div
          className="cursor-pointer overflow-hidden rounded-xl border border-[#EDE8FF] transition-all hover:border-[#D0C3FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF]"
          onClick={() => templateModal("frame1")}
        >
          <Image
            src={template7}
            width={322}
            height={501}
            alt=""
            className="size-full"
          />
        </div>
        <div
          className="cursor-pointer overflow-hidden rounded-xl border border-[#EDE8FF] transition-all hover:border-[#D0C3FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF]"
          onClick={() => templateModal("frame1")}
        >
          <Image
            src={template8}
            width={322}
            height={501}
            alt=""
            className="size-full"
          />
        </div>
      </div>

      <div
        className={`${
          isShow ? "block" : "hidden"
        } fixed left-0 top-0 z-50 h-screen w-full bg-[rgba(70,_76,_94,_.6)]`}
      >
        <TemplateModal
          visible={isShow}
          hide={setIsShow}
          content={modalContent}
        />
      </div>
    </section>
  );
}
