"use client";
import gsap from "gsap";
import Image from "next/image";
import Link from "next/link";
import { useEffect, useRef } from "react";

export function CommunityComponent() {
  const animationRef = useRef<any>();
  useEffect(() => {
    function startAnimation() {
      gsap.to("#community-star", {
        duration: 15,
        rotate: 360,
        repeat: -1,
        ease: "linear",
      });
      gsap.to("#community-title", {
        duration: 1,
        y: 20,
      });
      gsap.to("#w3yz-community", {
        duration: 2,
        color: "#F87C71",
        transform: "translate(0px, 0px)",
        delay: 0.5,
        onComplete: () => {
          gsap.to("#w3yz-community", {
            duration: 1,
            color: "#24262D",
            transform: "translate(0px, 0px)",
          });
        },
      });
      gsap.to("#community-fikir", {
        duration: 1,
        color: "#F87C71",
        transform: "translate(0px, 0px)",
        delay: 1.5,
        onComplete: () => {
          gsap.to("#community-fikir", {
            duration: 1,
            color: "#24262D",
            transform: "translate(0px, 0px)",
          });
        },
      });
      gsap.to("#community-deneyim", {
        duration: 1,
        color: "#F87C71",
        transform: "translate(0px, 0px)",
        delay: 1.75,
        onComplete: () => {
          gsap.to("#community-deneyim", {
            duration: 1,
            color: "#24262D",
            transform: "translate(0px, 0px)",
          });
        },
      });
      gsap.to("#community-ucretsiz", {
        duration: 3,
        color: "#F87C71",
        transform: "translate(0px, 0px)",
        delay: 2.3,
        onComplete: () => {
          gsap.to("#community-ucretsiz", {
            duration: 1,
            color: "#24262D",
            transform: "translate(0px, 0px)",
          });
        },
      });
      gsap.to("#community-yazi", {
        duration: 1,
        color: "#F87C71",
        transform: "translate(0px, 0px)",
        delay: 2.5,
        onComplete: () => {
          gsap.to("#community-yazi", {
            duration: 1,
            color: "#24262D",
            transform: "translate(0px, 0px)",
          });
        },
      });
      gsap.to("#community-etiket", {
        duration: 1,
        color: "#F87C71",
        transform: "translate(0px, 0px)",
        delay: 3,
        onComplete: () => {
          gsap.to("#community-etiket", {
            duration: 1,
            color: "#24262D",
            transform: "translate(0px, 0px)",
          });
        },
      });
      gsap.to("#community-is", {
        duration: 2,
        color: "#F87C71",
        transform: "translate(0px, 0px)",
        delay: 4,
        onComplete: () => {
          gsap.to("#community-is", {
            duration: 1,
            color: "#24262D",
            transform: "translate(0px, 0px)",
          });
        },
      });
      gsap.to("#community-takip", {
        duration: 3,
        color: "#F87C71",
        transform: "translate(0px, 0px)",
        delay: 5,
        onComplete: () => {
          gsap.to("#community-takip", {
            duration: 1,
            color: "#24262D",
            transform: "translate(0px, 0px)",
          });
        },
      });
      gsap.to("#community-description", {
        duration: 1,
        y: 20,
        delay: 0.5,
      });
      gsap.to("#community-link", { duration: 1, y: 20, delay: 1 });
      gsap.to("#community-svg", {
        duration: 1,
        y: 5,
        delay: 1,
        transform: "translate(0px, 0px) scale(1)",
        visibility: "inherit",
        scale: 1.2,
        repeat: -1,
        yoyo: true,
      });
    }

    const handleScroll = () => {
      const scrollPosition = window.scrollY;
      const animationOffset = animationRef.current.offsetTop - 150;

      if (scrollPosition >= animationOffset) {
        startAnimation();
        window.removeEventListener("scroll", handleScroll);
      }
    };

    window.addEventListener("scroll", handleScroll);
    return () => {
      window.removeEventListener("scroll", handleScroll);
    };
  }, []);

  return (
    <div
      className="bg-gradient-to-b from-rose-200 via-white to-white py-[130px]"
      id="community"
      ref={animationRef}
    >
      <div className="px-4 sm:px-6 md:px-10">
        <div className="mx-auto max-w-[1451px]">
          <h3 id="community-title" className="mb-8 text-[28px] text-[#DC3526]">
            W3YZ Community
          </h3>
          <div
            className="text-[clamp(16px,4vw,40px)]"
            id="community-description"
          >
            <span id="w3yz-community">W3YZ Community,</span>{" "}
            <span>herkesin özgürce İş trendlerini paylaşarak</span>{" "}
            <span id="community-fikir">fikirlerini,</span>{" "}
            <span id="community-deneyim">deneyimlerini</span>{" "}
            <span>paylaşabileceği </span>{" "}
            <span id="community-ucretsiz">ücretsiz bir platform.</span>{" "}
            {/* <span className=" flex items-center justify-center">
            <Image
              src="/assets/star_flair.svg"
              alt="community-lines"
              width={90}
              height={90}
            />
            <Image
              src="/assets/bubble.svg"
              alt="community-star"
              width={90}
              height={90}
              id="commu"
            />
          </span> */}
            <span>İlgilendiğiniz konularda</span>{" "}
            <span id="community-yazi"> yazılar</span>{" "}
            <span> oluşturabilir,</span>{" "}
            <span id="community-etiket">etiketler</span>{" "}
            <span>ekleyerek hedef kitlenizle bağlantı kurabilirsiniz. </span>{" "}
            <span id="community-is">İş trendlerini </span>{" "}
            <span>paylaşarak</span>{" "}
            <span id="community-takip">takipçilerinizle etkileşime geçin.</span>
          </div>

          <Link
            href="/"
            id="community-link"
            className="mt-5 flex justify-end gap-2 text-[18px] font-medium text-[#24262D]"
          >
            <span className="">{`Community'i Keşfet`}</span>
            <span>
              <svg
                id="community-svg"
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                fill="none"
                viewBox="0 0 24 24"
              >
                <g
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  clipPath="url(#clip0_462_41)"
                >
                  <path stroke="#24262D" d="M10 18h4"></path>
                  <path
                    stroke="#000"
                    d="M3 8a9 9 0 019 9v1l1.428-4.285a12 12 0 016.018-6.938L20 6.5"
                  ></path>
                  <path stroke="#000" d="M15 6h5v5"></path>
                </g>
                <defs>
                  <clipPath id="clip0_462_41">
                    <path fill="#fff" d="M0 0H24V24H0z"></path>
                  </clipPath>
                </defs>
              </svg>
            </span>
          </Link>
        </div>
        <div className="relative mt-16  hidden scale-75 items-end justify-center sm:flex xl:scale-100">
          <Image
            src="/assets/community-lines.svg"
            alt="community-lines"
            width={900}
            height={100}
          />
          <Image
            src="/assets/community-star.svg"
            alt="community-star"
            width={190}
            height={190}
            className="p-3 md:p-0"
            id="community-star"
          />
        </div>
      </div>
    </div>
  );
}
