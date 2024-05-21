"use client";

import Header from "./orderheader";
import LeftNavigation from "./left-navigation";

export default function LoginedLaylout({ children }: any) {
  return (
    <div className="bg-[#FCFCFD]">
      <Header />
      <section className="lg:flex">
        <LeftNavigation />
        {children}
      </section>
    </div>
  );
}
