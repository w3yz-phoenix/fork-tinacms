import Image from "next/image";
import { useEffect, useRef } from "react";

interface Properties {
  logo: any;
  title: string;
  description: string;
  visible: boolean;
  hide: any;
}

export function IntegrationsModal({
  logo,
  title,
  description,
  visible,
  hide,
}: Properties) {
  const reference = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleOutsideClick = (event: MouseEvent) => {
      if (
        reference.current &&
        !reference.current.contains(event.target as Node)
      ) {
        hide(false);
      }
    };

    window.addEventListener("mousedown", handleOutsideClick);

    return () => {
      window.removeEventListener("mousedown", handleOutsideClick);
    };
  }, [hide]);

  return (
    <div
      className={`fixed left-1/2 top-1/2 w-full max-w-[1000px] -translate-x-1/2 -translate-y-1/2 rounded-2xl border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 !shadow-[0px_0px_10px_0px_#D0C3FF] md:p-12 md:pt-8 ${
        visible ? "block" : "hidden"
      } transition-all`}
      ref={reference}
    >
      <div className="mb-2.5 flex w-full justify-end">
        <button
          className="border-none bg-transparent outline-none"
          onClick={() => hide(false)}
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="32"
            height="32"
            viewBox="0 0 32 32"
            fill="none"
          >
            <g clipPath="url(#clip0_473_19182)">
              <path
                d="M24 8L8 24"
                stroke="black"
                strokeWidth="2.66667"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
              <path
                d="M8 8L24 24"
                stroke="black"
                strokeWidth="2.66667"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </g>
            <defs>
              <clipPath id="clip0_473_19182">
                <rect width="32" height="32" fill="white" />
              </clipPath>
            </defs>
          </svg>
        </button>
      </div>
      <Image
        src={logo}
        width={265}
        height={80}
        alt={"logo"}
        className="object-cover"
      />
      <label className="mb-5 mt-12 block text-[16px] font-semibold text-[#030711] md:text-[24px]">
        {title}
      </label>
      <p
        className="text-[14px] font-medium text-[#030711] md:text-[18px]"
        dangerouslySetInnerHTML={{ __html: description }}
      />
    </div>
  );
}
