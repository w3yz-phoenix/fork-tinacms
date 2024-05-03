"use client";

import {
  tinaField,
  useGlobalConfigQuery,
  useTinaQuery,
  type TinaGraphql_GlobalConfigQuery,
} from "@w3yz/cms-tina";
import Image from "next/image";
import Link from "next/link";

export const Header = ({ globalConfigPath }: { globalConfigPath: string }) => {
  const { globalConfig } = useTinaQuery<TinaGraphql_GlobalConfigQuery>(
    useGlobalConfigQuery,
    {
      relativePath: globalConfigPath,
    }
  );

  return (
    <div className="flex w-full flex-col">
      <div className="hidden w-full flex-col lg:flex">
        <div className="flex items-center justify-between bg-white px-[60px] py-8">
          <Link href="/">
            <Image
              src={"/images/logo.svg"}
              width={189}
              height={29}
              alt="W3yz Furniture"
            />
          </Link>
          <div className="flex items-center gap-x-6 text-base font-normal text-[#292929] lg:gap-x-12 2xl:gap-x-[90px] 2xl:text-xl">
            <Link href="/shop">MAĞAZA</Link>
            <Link href="/coming-soon">BLOG</Link>
            <Link href="/coming-soon">İNDİRİM</Link>
            <Link href="/hakkimizda">HAKKIMIZDA</Link>
            <Link href="/iletisim">İLETİŞİM</Link>
          </div>
        </div>
      </div>
    </div>
  );
};
