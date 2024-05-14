"use client";
import Image from "next/image";

export function Eticaret() {
  return (
    <div className="relative flex w-full flex-col">
      <Image
        src="/assets/eticaret.jpg"
        width={1920}
        height={920}
        alt="w3yz"
        className=" object-cover "
      />
      <div className="absolute left-1/2 top-1/3 flex min-w-[300px] -translate-x-1/2 -translate-y-1/2 flex-col max-sm:mt-6 sm:min-w-[550px] md:min-w-[750px] lg:top-1/2 lg:min-w-[1000px] xl:mt-20 xl:min-w-[1200px] xl:-translate-y-2/3 2xl:min-w-[1430px] ">
        <div className="bg-gradient-to-b from-[#000] to-[#6018BB] bg-clip-text   text-[50px] font-bold  text-transparent sm:text-[80px] md:text-[100px] lg:text-[150px] xl:text-[200px] 2xl:text-[240px]">
          E ticaretin
        </div>
        <div className="bg-gradient-to-b from-[#000] to-[#6018BB] bg-clip-text text-end text-[50px]  font-bold text-transparent  sm:text-[80px] md:text-[100px] lg:text-[150px] xl:text-[200px] 2xl:text-[240px]">
          kısa yolu
        </div>
      </div>
    </div>
  );
}
