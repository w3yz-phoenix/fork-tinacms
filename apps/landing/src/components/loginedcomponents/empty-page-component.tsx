import Image from "next/image";
import Link from "next/link";

interface properties {
  image?: string;
  label?: string;
  p?: string;
  buttonText1?: string;
  link1?: string;
  buttonText2?: string;
  link2?: string;
}

export function EmptyPageComponent({
  image,
  label,
  p,
  buttonText1,
  link1,
  buttonText2,
  link2,
}: properties) {
  return (
    <div className="grid place-items-center text-center">
      <Image
        src={`${image}`}
        width={150}
        height={150}
        alt=""
        style={{
          maxWidth: "100%",
          height: "auto",
        }}
      />

      <label className="block my-7 mb-4 text-[#24262D] font-semibold text-[22px]">
        {label}
      </label>
      <p className="max-w-[466px] block mx-auto text-[#464C5E] text-[16px] font-medium">
        {p}
      </p>
      <div className="flex items-center gap-x-2 mt-6">
        <Link
          href={`${link1}`}
          className="min-w-[200px] grid place-items-center px-3 py-3 rounded-lg bg-[#3670FB] text-[16px] border border-transparent text-white font-medium"
        >
          {buttonText1}
        </Link>
        <Link
          href={`${link2}`}
          className="min-w-[200px] grid place-items-center px-3 py-3 rounded-lg bg-white text-[16px] border border-[#D7DAE0] text-[#565E73] font-medium"
        >
          {buttonText2}
        </Link>
      </div>
    </div>
  );
}
