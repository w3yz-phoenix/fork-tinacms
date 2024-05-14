import Image from "next/image";
import { useEffect, useRef } from "react";

import templateModal from "../../../public/assets/templateModal.png";

interface Properties {
  content: string;
  visible: boolean;
  hide: any;
}

export function TemplateModal({ content, visible, hide }: Properties) {
  const reference = useRef<HTMLDivElement>(null);
  console.log(content);
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
      className={`fixed left-1/2 top-1/2 z-50 h-[calc(100vh-100px)] max-h-[803px] w-[calc(100%-50px)] max-w-[80%] -translate-x-1/2 -translate-y-1/2 overflow-y-scroll rounded-xl border border-DEFAULT bg-white p-6 pt-0 shadow-[0px_4px_6px_-2px_rgba(54,_58,_68,_0.03),_0px_12px_16px_-4px_rgba(54,_58,_68,_0.08)] ${
        visible ? "block" : "hidden"
      }`}
      ref={reference}
    >
      <div className="sticky top-0 z-50 flex w-full justify-end bg-white px-2.5 py-6">
        <button
          className="border-none bg-white outline-none"
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

      <div className="size-full max-h-[1021px] rounded-lg border border-[#EDEEF1]">
        <Image src={templateModal} width={1920} height={100} alt="" />
      </div>
    </div>
  );
}
