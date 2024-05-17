"use server";

import { notFound } from "next/navigation";
import {
  createShopBreadcrumbs,
  formatMoney,
  getStringIfNotEmpty,
  invariant,
} from "@w3yz/tools/lib";

import { getProductsByCategory } from "#storefront/lib/product/product.api";
import { getShopPageData } from "#storefront/lib/shop.api";

import type { Metadata } from "next";

import { Breadcrumbs } from "../../../../../components/breadcrumbs";
import { ProductCard } from "../components/product-card";

export const generateMetadata = async (props: {
  params: { slugs?: string[] };
}): Promise<Metadata | undefined> => {
  const shopPageData = await getShopPageData(props.params.slugs);

  if (shopPageData.type !== "category" && shopPageData.type !== "all") {
    return;
  }

  if (shopPageData.type === "all") {
    return {
      title: "Ürünler",
      description: "Zivella'nın tüm ürünlerine göz atın.",
    };
  }

  const lastCategory = shopPageData.categories.at(-1);

  const response = await getProductsByCategory(lastCategory?.slug ?? "");

  invariant(response?.category, "Category should exist");

  const { category } = response;

  const metadata = {
    title: `${
      getStringIfNotEmpty(category.seoTitle) ??
      getStringIfNotEmpty(category.name) ??
      "Ürünler"
    } | Zivella`,
    description:
      getStringIfNotEmpty(category.seoDescription) ??
      getStringIfNotEmpty(category.name),
  };

  return metadata;
};

export default async function ProductListPage(props: {
  params: { slugs?: string[] };
}) {
  let response: Awaited<ReturnType<typeof getProductsByCategory>>;

  const shopPageData = await getShopPageData(props.params.slugs);
  if (shopPageData.type === "all") {
    response = await getProductsByCategory("all");
  } else if (shopPageData.type === "category") {
    const lastCategory = shopPageData.categories.at(-1);
    if (!lastCategory) {
      return;
    }

    response = await getProductsByCategory(lastCategory.slug);
  } else {
    return;
  }

  if (!response?.products?.length) {
    return notFound();
  }

  const { products } = response;
  const sortedProducts = products.sort(
    (a, b) => (a.rating ?? 0) - (b.rating ?? 0)
  );
  const categories =
    shopPageData.type === "category" ? shopPageData.categories : [];

  const breadcrumbs = createShopBreadcrumbs(categories);

  return (
    <div className="flex w-full flex-col">
      <div className="flex max-w-full flex-col pt-[24px] max-md:px-[12px]">
        <div className="flex w-full flex-row sm:px-[52px]">
          <Breadcrumbs breadcrumbs={breadcrumbs} />
        </div>
        <div className="mt-[4px] flex h-[50px] w-full items-center justify-center">
          <p className="text-[24px] font-normal text-[#4C4F52]">
            {breadcrumbs.at(-1)?.label}
          </p>
        </div>
        <div className="flex flex-wrap place-content-center justify-items-center py-[20px] md:place-content-start ">
          {sortedProducts.map((product) => (
            <div
              className="basis-full sm:basis-1/2 md:basis-1/3"
              key={product.id}
            >
              <ProductCard
                className="px-4 max-sm:w-[350px]"
                price={
                  formatMoney(
                    product.pricing?.priceRange?.stop?.gross.amount ?? 0,
                    product.pricing?.priceRange?.stop?.gross?.currency ?? "TRY"
                  ) ?? ""
                }
                productName={product.name}
                imageSrc={product.thumbnail?.url ?? ""}
                link={product.internalMeta.canonicalPath ?? ""}
                size={"md"}
              />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
