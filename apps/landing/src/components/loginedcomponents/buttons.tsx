"use client";

import Image from "next/image";

export default function WhiteButton({ icon, text, action }: any) {
  return (
    <button
      type="button"
      className="flex gap-2  px-3 py-2 bg-white border max-h-fit border-[#D7DAE0] rounded-lg text-[#565E73] text-[16px] font-medium"
      onClick={action}
    >
      {icon === false ? (
        ""
      ) : (
        <Image
          src={`/assets/${icon}`}
          width={22}
          height={22}
          alt=""
          style={{
            maxWidth: "100%",
            height: "auto",
          }}
        />
      )}
      {text}
    </button>
  );
}

export function PurpleButton({ icon, text, action }: any) {
  return (
    <button
      type="button"
      className="flex gap-2 px-3 py-2 bg-[#9153FF] border max-h-fit border-[#9153FF] rounded-lg text-white text-[16px] font-medium"
      onClick={action}
    >
      {icon === false ? (
        ""
      ) : (
        <Image
          src={`/assets/${icon}`}
          width={22}
          height={22}
          alt=""
          style={{
            maxWidth: "100%",
            height: "auto",
          }}
        />
      )}
      {text}
    </button>
  );
}

export function BlueButton({ icon, text, action }: any) {
  return (
    <button
      type="button"
      className="flex gap-2 px-3 py-2 bg-[#3670FB] border max-h-fit border-[#3670FB] rounded-lg text-white text-[16px] font-medium"
      onClick={action}
    >
      {icon === false ? (
        ""
      ) : (
        <Image
          src={`/assets/${icon}`}
          width={22}
          height={22}
          alt=""
          style={{
            maxWidth: "100%",
            height: "auto",
          }}
        />
      )}
      {text}
    </button>
  );
}
