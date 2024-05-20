"use client";

import Link from "next/link";

export default function PageLinks({ pageLinks }: any) {
  return (
    <ul className="border-b border-[#D7DAE0] px-6 flex pb-2">
      {pageLinks?.map((item: string, index: number) => (
        <li key={index}>
          <Link
            href={"#"}
            className="px-4 py-2 text-[#565E73] text-[14px] block rounded-lg hover:font-medium hover:text-[#24262D] hover:bg-[#F6F2FF]"
          >
            {item}
          </Link>
        </li>
      ))}
    </ul>
  );
}
