"use client";
import { useState } from "react";

import { Cerez } from "./cookie";
import { Privacy } from "./privacy";
import { Return } from "./return";

const Policies = {
  cerez: "Çerez Politikası",
  gizlilik: "Gizlilik Politikası",
  iade: "İade Politikası",
};

export function Politikalar() {
  const [activePolicy, setActivePolicy] = useState("cerez");

  const handlePolicyClick = (policy: string) => {
    setActivePolicy(policy);
  };

  return (
    <div className="mx-auto my-20 flex flex-col break-words bg-[#FFF]">
      <div className="px-2">
        <h3 className="text-xl font-semibold text-[#EC8065]">Yasal Metinler</h3>
        <h1 className="py-[16px] text-4xl font-semibold text-[#101828]">
          Kullanım Politikaları
        </h1>
        <p className="max-w-[650px] text-lg text-[#475467] xl:text-2xl">
          Ziyaretçilerimizin kullanıcı deneyimlerini geliştirebilmelerini
          sağlamak için sunduğumuz politikalar ile ilgili bilgi alın. Detaylı
          bilgi için bize ulaşmaktan çekinmeyin.
        </p>
      </div>
      <div>
        <div className="mt-5 flex flex-col gap-3 xl:flex-row">
          <div className="grid h-full min-w-[200px] grid-cols-1 sm:grid-cols-2 md:grid-cols-3 xl:sticky xl:top-24 xl:grid-cols-1">
            {Object.entries(Policies).map(([policyKey, policyName]) => (
              <div key={policyKey} className="flex flex-row pt-1 lg:pt-4">
                <div
                  className={`sm: ${
                    policyKey === activePolicy
                      ? " ml-2 h-9 w-[3px] rounded-[199px] bg-[#6018BB]"
                      : "hidden"
                  }`}
                />
                <button
                  className={` ml-2 ${
                    policyKey === activePolicy
                      ? "rounded-lg bg-[#F6F2FF] p-2 text-start text-[14px] text-[#24262D]"
                      : "bg-[#FFF] p-2 text-start text-[14px] text-[#565E73]"
                  }`}
                  onClick={() => handlePolicyClick(policyKey)}
                >
                  {policyName}
                </button>
              </div>
            ))}
          </div>
          <div className="flex max-w-[800px] flex-col bg-[#FAFAFC] p-4 max-lg:pt-8 lg:p-6 xl:max-w-[1161px]">
            {activePolicy === "cerez" && <Cerez />}
            {activePolicy === "gizlilik" && <Privacy />}
            {activePolicy === "iade" && <Return />}
          </div>
        </div>
      </div>
    </div>
  );
}
