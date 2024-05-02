import "./globals.css";
import { Inter as FontSans } from "next/font/google";
import { publicEnvironment } from "src/lib/environment";
import { cn } from "src/lib/utils";
import { Providers } from "src/lib/providers/providers";

import type { Metadata } from "next";

const fontSans = FontSans({
  subsets: ["latin"],
  variable: "--font-sans",
});

export async function generateMetadata(): Promise<Metadata> {
  const storefront = publicEnvironment.storefront;

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
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
