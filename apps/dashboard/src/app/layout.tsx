import { Inter as FontSans } from "next/font/google";
import "./shadcn.css";

import { cn } from "#shadcn/lib/utils";

import { TooltipProvider } from "#shadcn/components/tooltip";
import type { Metadata, Viewport } from "next";
import { Sidebar } from "#ui/sidebar";
import { Content } from "#ui/content";
import { Header } from "#ui/header";
import { Toaster } from "#shadcn/components/toaster";

const fontSans = FontSans({
  subsets: ["latin"],
  variable: "--font-sans",
});

export async function generateMetadata(): Promise<Metadata> {
  return {
    title: "W3YZ Dashboard",
    description: "Welcome to the W3YZ Dashboard!",
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

export default async function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <head />
      <body
        className={cn(
          "min-h-screen bg-background font-sans antialiased",
          fontSans.variable
        )}
      >
        <TooltipProvider>
          <div className="flex flex-col w-full min-h-screen bg-muted/40">
            <Sidebar />
            <div className="flex flex-col sm:gap-4 sm:py-4 sm:pl-14">
              <Header />
              <Content>{children}</Content>
            </div>
          </div>
        </TooltipProvider>
        <Toaster />
      </body>
    </html>
  );
}
