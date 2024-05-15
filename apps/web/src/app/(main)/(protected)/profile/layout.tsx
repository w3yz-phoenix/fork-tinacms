"use server";

import type { Metadata } from "next";

import { ProfileNavigationLink } from "../../checkout/components/profile-links";

export async function generateMetadata(): Promise<Metadata> {
  return {
    title: "Furniture",
    description: "Furniture Storefront",
  };
}

export default async function ProfileSettingLayout(props: {
  children: React.ReactNode;
}) {
  return (
    <main className="flex min-h-[calc(100vh-96px)] items-center bg-white">
      <div className="container mx-auto px-4">
        <div className="flex w-full justify-between gap-[50px] lg:gap-[100px]">
          <ProfileNavigationLink />
          <div className="flex-1">{props.children}</div>
        </div>
      </div>
    </main>
  );
}
