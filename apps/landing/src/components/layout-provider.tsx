"use client";
import { usePathname } from "next/navigation";
import { ReactNode } from "react";

import { Footer } from "./footer/footer";
import { Header } from "./header/header";

interface LayoutProviderProperties {
  children: ReactNode;
}

export const LayoutProvider: React.FC<LayoutProviderProperties> = ({
  children,
}) => {
  const pathname = usePathname();
  const isPublicPage =
    pathname.startsWith("/coming-soon") || pathname.startsWith("/iletisim");

  return (
    <div>
      {!isPublicPage && <Header />}
      {children}
      {!isPublicPage && <Footer />}
    </div>
  );
};
