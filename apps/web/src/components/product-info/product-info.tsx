import Image from "next/image";
import Link from "next/link";
import { ReactNode } from "react";
import { z } from "zod";
import { isPresent } from "@w3yz/tools/lib";

import { cva, cn } from "#shadcn/lib/utils";
import {
  ProductPageStateSchema,
  getProductStateLinkGenerator,
} from "#web/lib/product/product.utils";

import installmentImg1 from "./images/bonus-card.png";
import installmentImg2 from "./images/bankkart-card.png";
import installmentImg3 from "./images/advantage-card.png";
import installmentImg4 from "./images/axess-card.png";
import installmentImg5 from "./images/card-finans.png";
import installmentImg6 from "./images/maximum_card.png";
import installmentImg7 from "./images/world-card.png";
import installmentImg8 from "./images/saglam-card.png";
import installmentImg9 from "./images/paraf-card.png";

// FIXME: #W3YZ-0000: Remove this once we figure out a better way to handle classnames.
// eslint-disable-next-line tailwindcss/no-custom-classname
export const ProductInfoVariants = cva("bg-white", {
  variants: {
    variant: {
      default: "",
      destructive: "",
    },
  },
  defaultVariants: {
    variant: "default",
  },
});

export const ProductInfoSchema = z.object({
  className: z.string().optional(),
  title: z.string(),
  technicalInfo: z.custom<ReactNode>().optional(),
  stockCode: z.string(),
  productWeight: z.string(),
  productSize: z.string(),
  warranty: z.string(),
  productInformation: z.custom<ReactNode>().optional(),
  technicalInformation: z.custom<ReactNode>().optional(),
  pageState: ProductPageStateSchema,
  canonicalPath: z.string(),
});

export type ProductInfoProperties = z.infer<typeof ProductInfoSchema>;

type TabbedInfoProperties = {
  defaultTab: string;
  currentTab: string;
  tabs: {
    link: string;
    title: string;
    slug: string;
    render: () => ReactNode;
  }[];
};

function TabbedInfo(props: TabbedInfoProperties) {
  return (
    <div className="bg-white font-medium text-[#4C4F52]">
      <div className="flex w-full gap-x-5 border-b border-[#CFD1D2]  pl-0">
        {props.tabs.map((tab) => (
          <Link
            replace
            shallow
            scroll={false}
            key={tab.slug}
            href={tab.link}
            className={cn(
              "max-w-[230px]  p-2.5 text-[#4C4F52] md:text-[20px]",
              props.currentTab === tab.slug ? "border-[#686C72] border-b-2" : ""
            )}
          >
            {tab.title}
          </Link>
        ))}
      </div>
      <div>
        {props.tabs.find((tab) => tab.slug === props.currentTab)?.render()}
      </div>
    </div>
  );
}

export function ProductInfo({
  title,
  stockCode,
  productWeight,
  productSize,
  warranty,
  productInformation,
  technicalInformation,
  canonicalPath,
  pageState,
}: ProductInfoProperties) {
  const createStateLink = getProductStateLinkGenerator(canonicalPath);
  const currentTab = pageState.infoTab ?? "product-info";
  const productInfoTab = {
    slug: "product-info",
    title: "Ürün Bilgisi",
    link: createStateLink(pageState, { infoTab: "product-info" }),
    render: () => (
      <div>
        <div className="mb-8 mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2">
          <div>
            <div className="mb-2">{title}</div>
            <div className="text-[#686C72]">{productInformation}</div>
          </div>
          <div>
            <div className="mb-2">Teknik Bilgiler</div>
            <div className="text-[#686C72]">{technicalInformation}</div>
          </div>
        </div>
        <div className="w-full">
          <table className="w-full">
            <thead className="bg-[#F5F6F6] md:text-base ">
              <tr className="flex">
                <th className="flex-1 border-r-2 p-1.5 text-start font-medium sm:p-2.5">
                  Stok Kodu
                </th>
                <th className="flex-1 border-r-2 p-1.5 text-start font-medium sm:p-2.5">
                  Ürün Ağırlığı
                </th>
                <th className="flex-1 border-r-2 p-1.5 text-start font-medium sm:p-2.5">
                  Ürün Ölçücü
                </th>
                <th className="flex-1 p-1.5 text-start font-medium sm:p-2.5">
                  Garanti Süresi
                </th>
              </tr>
            </thead>
            <tbody className="text-base">
              <tr className="flex">
                <td className="min-w-[70px] flex-1 border-r-2 p-1.5 sm:min-w-[84px] sm:p-2.5">
                  {stockCode}
                </td>
                <td className="min-w-[70px] flex-1 border-r-2 p-1.5 sm:min-w-[84px] sm:p-2.5">
                  {productWeight}
                </td>
                <td className="min-w-[70px] flex-1 border-r-2 p-1.5 sm:min-w-[84px] sm:p-2.5">
                  {productSize}
                </td>
                <td className="min-w-[70px] flex-1 p-1.5 sm:min-w-[84px] sm:p-2.5">
                  {warranty}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    ),
  };

  const productInstallmentTab = {
    slug: "product-installment",
    title: "Taksit Seçenekleri",
    link: createStateLink(pageState, { infoTab: "product-installment" }),
    render: () => (
      <div className="mt-6">
        <label className="mb-2 block text-[16px] font-normal text-[#4C4F52]">
          Taksit Seçenekleri
        </label>
        <p className="mb-6 block text-[16px] font-normal text-[#686C72]">
          Banka kartları için taksit uygulaması bulunmamakla birlikte, kampanya
          sadece bireysel kredi kartlarında geçerlidir.
        </p>
        <div className="grid grid-cols-2">
          <div className="border-r border-[#CFD1D2] bg-[#F5F6F6] p-2.5 text-[16px] font-medium text-[#4C4F52]">
            Banka Adı
          </div>
          <div className=" bg-[#F5F6F6] p-2.5 text-[16px] font-medium text-[#4C4F52]">
            Taksit Sayısı
          </div>
          <div className="border-b border-r border-[#CFD1D2] p-2.5 text-[#4C4F52]">
            <Image
              src={installmentImg1}
              width={87}
              height={25}
              alt=""
              className="h-[22px] w-auto object-contain"
            />
          </div>
          <div className="border-b border-[#CFD1D2] p-2.5 text-[16px] font-normal text-[#4C4F52]">
            2-3-6-9
          </div>
          <div className="border-b border-r border-[#CFD1D2] p-2.5 text-[#4C4F52]">
            <Image
              src={installmentImg2}
              width={87}
              height={25}
              alt=""
              className="h-[22px] w-auto object-contain"
            />
          </div>
          <div className="border-b border-[#CFD1D2] p-2.5 text-[16px] font-normal text-[#4C4F52]">
            2-3-6-9
          </div>
          <div className="border-b border-r border-[#CFD1D2] p-2.5 text-[#4C4F52]">
            <Image
              src={installmentImg3}
              width={87}
              height={25}
              alt=""
              className="h-[22px] w-auto object-contain"
            />
          </div>
          <div className="border-b border-[#CFD1D2] p-2.5 text-[16px] font-normal text-[#4C4F52]">
            2-3-6-9
          </div>
          <div className="border-b border-r border-[#CFD1D2] p-2.5 text-[#4C4F52]">
            <Image
              src={installmentImg4}
              width={87}
              height={25}
              alt=""
              className="h-[22px] w-auto object-contain"
            />
          </div>
          <div className="border-b border-[#CFD1D2] p-2.5 text-[16px] font-normal text-[#4C4F52]">
            2-3-6-9
          </div>
          <div className="border-b border-r border-[#CFD1D2] p-2.5 text-[#4C4F52]">
            <Image
              src={installmentImg5}
              width={87}
              height={25}
              alt=""
              className="h-[22px] w-auto object-contain"
            />
          </div>
          <div className="border-b border-[#CFD1D2] p-2.5 text-[16px] font-normal text-[#4C4F52]">
            2-3-6-9
          </div>
          <div className="border-b border-r border-[#CFD1D2] p-2.5 text-[#4C4F52]">
            <Image
              src={installmentImg6}
              width={87}
              height={25}
              alt=""
              className="h-[22px] w-auto object-contain"
            />
          </div>
          <div className="border-b border-[#CFD1D2] p-2.5 text-[16px] font-normal text-[#4C4F52]">
            2-3-6-9
          </div>
          <div className="border-b border-r border-[#CFD1D2] p-2.5 text-[#4C4F52]">
            <Image
              src={installmentImg7}
              width={87}
              height={25}
              alt=""
              className="h-[22px] w-auto object-contain"
            />
          </div>
          <div className="border-b border-[#CFD1D2] p-2.5 text-[16px] font-normal text-[#4C4F52]">
            2-3-6-9
          </div>
          <div className="border-b border-r border-[#CFD1D2] p-2.5 text-[#4C4F52]">
            <Image
              src={installmentImg8}
              width={87}
              height={25}
              alt=""
              className="h-[22px] w-auto object-contain"
            />
          </div>
          <div className="border-b border-[#CFD1D2] p-2.5 text-[16px] font-normal text-[#4C4F52]">
            2-3-6-9
          </div>
          <div className="border-b border-r border-[#CFD1D2] p-2.5 text-[#4C4F52]">
            <Image
              src={installmentImg9}
              width={87}
              height={25}
              alt=""
              className="h-[22px] w-auto object-contain"
            />
          </div>
          <div className="border-b border-[#CFD1D2] p-2.5 text-[16px] font-normal text-[#4C4F52]">
            2-3-6-9
          </div>
        </div>
      </div>
    ),
  };

  return (
    <TabbedInfo
      currentTab={currentTab}
      defaultTab="product-info"
      tabs={[productInfoTab, productInstallmentTab].filter(isPresent)}
    />
  );
}
