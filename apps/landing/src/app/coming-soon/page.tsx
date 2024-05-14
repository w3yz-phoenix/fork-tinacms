import Link from "next/link";

import { Header } from "@/components/header/header";

export default function ComingSoonPage() {
  return (
    <div className="flex min-h-screen flex-col">
      <Header />
      <div className="flex flex-1 items-center justify-center bg-gradient-to-tr from-[#B493ED] to-[#A39FD700]">
        <main className="flex flex-col items-center justify-center">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="40"
            height="40"
            fill="none"
            viewBox="0 0 40 40"
          >
            <mask
              id="mask0_613_2118"
              style={{ maskType: "alpha" }}
              width="40"
              height="40"
              x="0"
              y="0"
              maskUnits="userSpaceOnUse"
            >
              <path fill="#D9D9D9" d="M0 0H40V40H0z"></path>
            </mask>
            <g mask="url(#mask0_613_2118)">
              <path
                fill="#1C1B1F"
                d="M7.972 32.028l12.64-4.5-8.167-8.195-4.473 12.695zm30.514-20.514c-.213.213-.467.32-.764.32-.296 0-.55-.107-.764-.32l-.097-.098c-.481-.481-1.05-.726-1.708-.736-.657-.009-1.236.236-1.736.736l-9.098 9.098c-.212.213-.467.32-.763.32-.297 0-.551-.107-.764-.32a1.043 1.043 0 01-.32-.764c0-.296.107-.551.32-.764l9.014-9.014c.889-.889 1.995-1.338 3.32-1.347 1.323-.01 2.43.43 3.319 1.32l.041.041c.213.213.32.467.32.764 0 .296-.107.55-.32.764zm-22.305-5.14c.213-.212.467-.319.764-.319.296 0 .55.107.764.32l.319.32c.944.944 1.412 2.106 1.403 3.485-.01 1.38-.486 2.542-1.43 3.486l-.32.32c-.213.213-.468.32-.764.32-.297 0-.551-.107-.764-.32a1.042 1.042 0 01-.32-.764c0-.296.107-.55.32-.764l.403-.403c.555-.555.82-1.199.791-1.93-.027-.732-.291-1.347-.791-1.847l-.375-.375a1.042 1.042 0 01-.32-.764c0-.297.107-.551.32-.764zm6.944-3.138c.213-.213.468-.32.764-.32s.55.107.764.32l1.875 1.875c.87.889 1.315 1.99 1.333 3.305.019 1.315-.416 2.417-1.305 3.306l-5.514 5.514c-.213.213-.468.32-.764.32s-.551-.107-.764-.32a1.042 1.042 0 01-.32-.764c0-.296.107-.55.32-.764l5.458-5.458c.482-.482.718-1.093.709-1.834-.01-.74-.255-1.351-.736-1.833l-1.82-1.82a1.042 1.042 0 01-.32-.763c0-.296.107-.551.32-.764zM35.903 23.93c-.213.213-.468.32-.764.32s-.55-.107-.764-.32l-1.57-1.569c-.555-.556-1.161-.833-1.819-.833-.657 0-1.264.277-1.82.833l-1.513 1.514c-.213.213-.468.32-.764.32s-.55-.107-.764-.32a1.042 1.042 0 01-.32-.764c0-.296.107-.551.32-.764l1.43-1.43c.945-.945 2.08-1.426 3.403-1.445 1.325-.018 2.459.444 3.403 1.389l1.542 1.542c.213.213.32.467.32.764 0 .296-.107.55-.32.763zM4.306 33.89l6.236-17.39c.12-.305.298-.536.534-.694a1.362 1.362 0 011.271-.139c.167.065.324.172.473.32l11.25 11.139c.148.148.254.305.319.472.065.167.097.343.097.528 0 .278-.079.535-.236.77a1.439 1.439 0 01-.694.535L6.11 35.694a1.31 1.31 0 01-.805.049 1.46 1.46 0 01-1.049-1.049c-.07-.259-.053-.528.049-.805z"
              ></path>
            </g>
          </svg>
          <p className=" pt-[20px] text-center text-[24px] font-semibold text-[#252627] ">
            Çok Yakında
          </p>
          <Link
            className="pt-[30px] text-[16px] font-medium text-[#4C4F52]"
            href="/"
          >
            Ana Sayfaya Dön
          </Link>
        </main>
      </div>
    </div>
  );
}
