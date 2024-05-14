import Image from "next/image";

export const Commerce = () => {
  return (
    <div className="flex flex-col items-center justify-center gap-[105px]">
      <div className="flex flex-col items-center justify-center gap-4">
        <p className="text-center text-sm font-medium leading-none text-neutral-700">
          Biz Kimiz
        </p>
        <p className="text-center text-[64px] font-medium leading-[80px] text-[#030711]">
          Eksiksiz E-ticaret Deneyimi
        </p>
        <p className="max-w-[1122px] text-center text-3xl font-normal leading-loose text-[#030711]">
          W3yz e-ticarete yeni başlayanlara ve gelişmek isteyenlere modüler
          çözümler sunan bir web geliştirme platformudur.
        </p>
      </div>
      <Image
        src={"/assets/commerce.png"}
        alt={"commerce"}
        width={1364}
        height={570}
      />
    </div>
  );
};
