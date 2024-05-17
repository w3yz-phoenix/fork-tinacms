"use client";
import Image from "next/image";
import { gsap } from "gsap";
import { useEffect } from "react";

export function Eticaret() {
  useEffect(() => {
    const animateLetters = () => {
      const letters = gsap.utils.toArray(
        "#firstLetter span, #lettersSecond span"
      );
      gsap.set(letters, { opacity: 0, y: 500 });

      gsap.to(letters, {
        duration: 0.4,
        opacity: 1,
        y: 0,
        stagger: 0.2 * 1.5,
        yoyo: true,
        animationDelay: 5,
        onComplete: function () {
          gsap.delayedCall(0.6, animateW3YZ);
        },
      });
    };

    const animateW3YZ = () => {
      if (window.innerWidth <= 991) {
        gsap.to("#w3yzText", {
          opacity: 1,
          stagger: 0.2 * 1.5,
          duration: 1,
          y: -30,
          display: "flex",
          yoyo: true,
          repeat: -1,
        });
      }

      if (window.innerWidth >= 991) {
        gsap.to("#w3yzText", {
          opacity: 1,
          duration: 1,
          stagger: 0.2 * 1.5,
          y: -50,
          display: "flex",
          yoyo: true,
          repeat: -1,
        });
      }

      gsap.to("#firstLetter, #lettersSecond", {
        opacity: 0,
        display: "none",
      });
    };

    animateLetters();
  }, []);

  return (
    <div className="relative flex max-h-screen min-h-[180px] w-full flex-col overflow-hidden">
      <div className="z-20 max-h-[180px] min-w-[300px] overflow-hidden px-5 max-sm:mt-6 sm:max-h-fit sm:min-w-[550px] md:min-w-[750px] lg:min-w-[1000px] xl:min-w-[1200px] 2xl:min-w-[1430px]">
        <div
          className="bg-gradient-to-b from-[#000] to-[#6018BB] bg-clip-text text-[50px] font-bold text-transparent sm:text-[80px] md:text-[100px] lg:text-[130px] xl:text-[150px] 2xl:text-[240px]"
          id="firstLetter"
        >
          <span>E</span>
          <span>-ticaretin</span>
        </div>
        <div
          className="bg-gradient-to-b from-[#000] to-[#6018BB] bg-clip-text text-end text-[50px] font-bold text-transparent sm:text-[80px] md:-mt-10 md:text-[100px] lg:text-[130px] xl:text-[150px] 2xl:text-[240px]"
          id="lettersSecond"
        >
          <span>kısa</span>
          <span>yolu</span>
        </div>
        {/* Placeholder for "W3YZ" text */}
        <div
          id="w3yzText"
          className="hidden h-[150px] items-center justify-center bg-gradient-to-b from-[#000] to-[#6018BB] bg-clip-text text-end text-[50px] font-bold text-transparent opacity-0 sm:h-[calc(50vh-180px)] sm:text-[calc(80vh-180px)] md:h-[calc(100vh-180px)] md:text-[100px] lg:text-[150px] xl:text-[200px] 2xl:text-[240px]"
        >
          w3yz
        </div>
      </div>
      <Image
        src="/assets/eticaret.jpg"
        width={1920}
        height={920}
        alt="w3yz"
        className="absolute left-0 top-0 z-10 w-full"
      />
    </div>
  );
}
