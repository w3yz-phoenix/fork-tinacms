import { type Metadata, type Viewport } from "next";
import { Poppins } from "next/font/google";

import { LayoutProvider } from "@/components/layout-provider";
import "./globals.css";

const poppins = Poppins({
  weight: ["100", "200", "300", "400", "500", "600", "700", "800", "900"],
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "W3yz",
  description: "Build. Grow. Publish.",
  metadataBase: process.env.NEXT_PUBLIC_STOREFRONT_URL
    ? new URL(process.env.NEXT_PUBLIC_STOREFRONT_URL)
    : undefined,
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="scroll-smooth bg-gray-100">
      <body className={poppins.className}>
        <LayoutProvider>{children}</LayoutProvider>
      </body>
    </html>
  );
}
