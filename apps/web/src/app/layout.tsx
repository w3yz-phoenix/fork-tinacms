import "../shadcn.css";
import { Inter as FontSans } from "next/font/google";
import { cn } from "@@shadcn/lib/utils";
import { W3YZProvider } from "@@ui/core/components/w3yz-provider/w3yz-provider";
import { publicEnvironment } from "@w3yz/tools/lib";

import type { Metadata, Viewport } from "next";

const fontSans = FontSans({
  subsets: ["latin"],
  variable: "--font-sans",
});

export async function generateMetadata(): Promise<Metadata> {
  const storefront = publicEnvironment.ecom;

  return {
    title: storefront.name,
    description: storefront.name,
    metadataBase: storefront.url ? new URL(storefront.url) : undefined,
  };
}

export async function generateViewport(): Promise<Viewport> {
  return {
    width: "device-width",
    initialScale: 1,
    maximumScale: 1,
    userScalable: false,
  };
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head />
      <body
        className={cn(
          "min-h-screen bg-background font-sans antialiased",
          fontSans.variable
        )}
      >
        <W3YZProvider>{children}</W3YZProvider>
      </body>
    </html>
  );
}
