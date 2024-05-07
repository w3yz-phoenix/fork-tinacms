"use client";

import { IconX } from "@tabler/icons-react";
import Image from "next/image";
import Link from "next/link";
import { createPortal } from "react-dom";

import { cn } from "@/zivella-ui/lib";

import type { fetchAvailableCartelaChoices } from "./product-data/product.api";

import {
  getProductStateLinkGenerator,
  type ProductPageStateType,
} from "./common";

const placeholderImagePath = "/images/loading.svg";

export function VariantDrawer(props: {
  canonicalPath: string;
  pageState: ProductPageStateType;
  choices: Awaited<ReturnType<typeof fetchAvailableCartelaChoices>>;
}) {
  "use client";

  const createStateLink = getProductStateLinkGenerator(props.canonicalPath);

  return createPortal(
    <div className="fixed inset-0">
      <div className=" h-full w-screen bg-[#53565A66]"></div>
      <div className="fixed right-0 top-0 overflow-y-scroll bg-white">
        <div className="">
          <div className="flex items-start justify-between p-2 sm:p-6">
            <div className=" text-[#53565A]">
              <h4 className="mb-3 text-4xl font-medium">Malzemeler</h4>
              <p className="text-[#53565A]">Bir malzeme seçiniz.</p>
            </div>
            <Link
              className=""
              href={createStateLink(props.pageState, {
                cartelaDrawer: undefined,
              })}
            >
              <IconX size={24} color="#53565A" />
            </Link>
          </div>
          <div className="h-px w-full bg-[#C2CAD5] font-medium"></div>

          <div className="h-screen overflow-x-hidden overflow-y-scroll py-2 pt-0 text-[#83878D] ">
            <div className="pb-[200px]">
              <div>
                <div className="bg-[#FAFAFA] p-2.5 pl-6 text-[#83878D]">
                  Malzeme Secenekleri
                </div>
                {/* <p className="px-2 text-[12px] sm:px-6">aaa</p> */}
                <div className="mt-3 grid grid-cols-3 gap-x-6 gap-y-7 px-2 pb-10 sm:px-6 lg:grid-cols-4">
                  {props.choices.map((choice) => {
                    const variantStyles = {
                      default:
                        "text-center px-[10px] py-[5px] cursor-default rounded text-[#4C4F52] bg-white border border-[#CFD1D2]",
                      selected:
                        "bg-[#F5F6F6] border-[#ADB0B3] text-[#4C4F52] cursor-default",
                      disabled:
                        "cursor-not-allowed bg-white text-[#E5E6E8] border-[#E5E6E8]",
                      available:
                        "cursor-pointer hover:bg-[#F5F6F6] hover:text-[#4C4F52] hover:border-[#ADB0B3]",
                    };

                    const isSelected = props.pageState.cartela === choice.slug;

                    return (
                      <Link
                        replace
                        shallow
                        scroll={false}
                        key={choice.slug}
                        href={createStateLink(props.pageState, {
                          cartela: choice.slug ?? "",
                          cartelaDrawer: false,
                        })}
                        className={cn([
                          "cursor-not-allowed",
                          variantStyles.default,
                          variantStyles.available,
                          isSelected && variantStyles.selected,
                        ])}
                      >
                        <div className="mb-1">{choice.name}</div>
                        <Image
                          src={choice.file?.url ?? placeholderImagePath}
                          alt={choice.name ?? ""}
                          width={125}
                          height={90}
                        />
                      </Link>
                    );
                  })}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>,
    document.querySelector("#global-portal-target") ??
      document.createElement("div")
  );
}
