"use server";

import { ChevronDownIcon, ChevronUpIcon } from "@radix-ui/react-icons";
import { type Metadata, type ResolvingMetadata } from "next";
import Image from "next/image";
import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { type Product, type WithContext } from "schema-dts";
import { z } from "zod";
import { formatMoney, invariant } from "@w3yz/tools/lib";
import { publicEnvironment } from "@@ui/core/lib/environment";

import {
  fetchAvailableCartelaChoices,
  fetchProductDetails,
  fetchProductVariantDetails,
  type DetailedProductType,
  type DetailedProductVariantType,
} from "@@web/lib/product/product.api";
import {
  ProductPageStateSchema,
  getProductStateLinkGenerator,
} from "@@web/lib/product/product.utils";
import { ProductInfo } from "@@web/components/product-info/product-info";

import { DangerousSaleorRichText } from "../../../../../components/dangerous-saleor-rich-text";
import { getShopPageData } from "../../../../../lib/shop.api";
import { Breadcrumbs } from "../../../../../components/breadcrumbs";

// import { AddToCartButton } from "./add-to-cart-button";

const getNonEmptyString = (value: string | null | undefined) =>
  value && value.length > 0 ? value : undefined;

const getAttribute = (product: DetailedProductType, slug: string) => {
  const attributeItem = product?.attributes.find(
    (item) => item.attribute.slug === slug
  );

  return {
    name: getNonEmptyString(attributeItem?.values[0]?.name),
    richText: getNonEmptyString(attributeItem?.values[0]?.richText),
    plainText: getNonEmptyString(attributeItem?.values[0]?.plainText),
    value: getNonEmptyString(attributeItem?.values[0]?.value),
    slug: attributeItem?.attribute.slug,
  };
};

export async function generateMetadata(
  props: {
    params: { slugs?: string[] };
    searchParams: { variant?: string };
  },
  parent: ResolvingMetadata
): Promise<Metadata | undefined> {
  const shopPageData = await getShopPageData(props.params.slugs);
  if (shopPageData.type !== "product") {
    return;
  }

  invariant(shopPageData.product?.id, "ID must be defined");

  const product = await fetchProductDetails(shopPageData.product.id);

  invariant(product?.id, "Product must be defined");

  const variant = await fetchProductVariantDetails(
    props.searchParams.variant ?? product.variants?.[0]?.id
  );

  const productName = product.seoTitle || product.name;
  const variantName = variant?.name;

  const productNameAndVariant = variantName
    ? `${productName} / ${variantName}`
    : productName;

  const resolvedParent = await parent;

  return {
    title: `${product.name} | ${
      product.seoTitle || resolvedParent.title?.absolute
    }`,
    description: product.seoDescription || productNameAndVariant,
    alternates: {
      canonical: publicEnvironment.storefront
        ? publicEnvironment.storefront + product.internalMeta.canonicalPath
        : undefined,
    },
    openGraph: product.thumbnail
      ? {
          images: [
            {
              url: product.thumbnail.url,
              alt: product.name,
            },
          ],
        }
      : undefined,
  };
}

const ProductJsonLd = ({
  product,
  variant,
}: {
  product: Awaited<ReturnType<typeof fetchProductDetails>>;
  variant: DetailedProductVariantType;
}) => {
  invariant(product?.id, "Product must be defined");

  const productJsonLd: WithContext<Product> = {
    "@context": "https://schema.org",
    "@type": "Product",
    image: product.thumbnail?.url,
    ...(variant
      ? {
          name: `${product.name} - ${variant.name}`,
          description:
            product.seoDescription || `${product.name} - ${variant.name}`,
          offers: {
            "@type": "Offer",
            availability: variant.quantityAvailable
              ? "https://schema.org/InStock"
              : "https://schema.org/OutOfStock",
            priceCurrency: variant.pricing?.price?.gross.currency,
            price: variant.pricing?.price?.gross.amount,
          },
        }
      : {
          name: product.name,

          description: product.seoDescription || product.name,
          offers: {
            "@type": "AggregateOffer",
            availability: product.variants?.some(
              (variant) => variant.quantityAvailable
            )
              ? "https://schema.org/InStock"
              : "https://schema.org/OutOfStock",
            priceCurrency: product.pricing?.priceRange?.start?.gross.currency,
            lowPrice: product.pricing?.priceRange?.start?.gross.amount,
            highPrice: product.pricing?.priceRange?.stop?.gross.amount,
          },
        }),
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(productJsonLd),
        }}
      />
    </>
  );
};

export default async function ProductDetailPage(props: {
  params: { slugs?: string[] };
  searchParams: z.infer<typeof ProductPageStateSchema>;
}) {
  const shopPageData = await getShopPageData(props.params.slugs);

  if (shopPageData.type !== "product") {
    return;
  }

  invariant(shopPageData.product?.id, "ID must be defined");

  const product = await fetchProductDetails(shopPageData.product.id);

  invariant(product?.category, "Category must be defined");

  const cartela = product?.cartelaImage?.values[0];

  const availableCartelaChoices = cartela
    ? await fetchAvailableCartelaChoices(cartela?.slug ?? "")
    : [];

  const pageState = ProductPageStateSchema.parse({
    category: product.category.slug,
    slug: product.slug,
    ...props.searchParams,
  });

  const selectedCartela = availableCartelaChoices.find(
    (c) => c.slug === pageState.cartela
  );

  const createStateLink = getProductStateLinkGenerator(
    product.internalMeta.canonicalPath
  );

  const variants = product.variants;
  const selectedVariantID = pageState?.variant ?? variants?.[0]?.id;
  const variant = await fetchProductVariantDetails(selectedVariantID);

  if (!variant) {
    return notFound();
  }

  const media =
    ((variant.media?.length && variant.media) || undefined) ??
    ((product.media?.length && product.media) || undefined) ??
    [];

  if (
    !pageState?.product ||
    !pageState?.variant ||
    !pageState?.currentImageId ||
    !pageState?.quantity ||
    pageState?.quantity < 1
  ) {
    const link =
      createStateLink(pageState, {
        product: product.id,
        variant: pageState?.variant ?? variant?.id,
        quantity: pageState?.quantity ?? 1,
        currentImageId: media[0]?.id,
        infoTab: "product-info",
      }) ?? product.internalMeta.canonicalPath;

    return redirect(link);
  }

  if (availableCartelaChoices.length > 0 && !selectedCartela) {
    const link =
      createStateLink(pageState, {
        cartela: availableCartelaChoices[0]?.slug ?? "",
      }) ?? product.internalMeta.canonicalPath;

    return redirect(link);
  }

  invariant(pageState.product === product.id, "Product ID mismatch");

  const stockCode = variant.sku ?? "";
  const productionTime = getAttribute(product, "tahmini-uretim-suresi");
  const warrantyTime = getAttribute(product, "garanti-suresi");
  const productDimensions = getAttribute(product, "urun-olcusu");
  const productInformation = getAttribute(product, "urun-bilgisi");
  const technicalInformation = getAttribute(product, "urun-teknik-bilgisi");
  const productWeight = getAttribute(product, "urun-agirligi");
  const currentImage = media.find(
    (image) => image.id === pageState.currentImageId
  );

  if (!currentImage) {
    const link = createStateLink(pageState, {
      currentImageId: media[0]?.id,
    });

    return redirect(link);
  }

  const isAvailable = Boolean(
    variant.quantityAvailable && variant.quantityAvailable > 0
  );

  return (
    <>
      <ProductJsonLd product={product} variant={variant} />
      <div className="mx-auto mt-3 max-w-screen-2xl px-4 sm:px-[52px]">
        <Breadcrumbs breadcrumbs={product.internalMeta.breadcrumbs} />

        <div className="my-6 flex flex-col gap-7 xl:flex-row xl:gap-7">
          <div className="flex-1">
            <div className="flex">
              <div className="mr-1 flex max-h-[70vw] flex-col gap-2 overflow-y-auto overflow-x-hidden sm:mr-4 sm:gap-6 md:h-full md:gap-2  xl:max-h-[520px] ">
                {media.map((image) => (
                  <Link
                    replace
                    shallow
                    scroll={false}
                    key={image.id}
                    href={createStateLink(pageState, {
                      currentImageId: image.id,
                    })}
                  >
                    <Image
                      className={`mr-1 max-h-[95px] min-h-[95px] w-[79px] cursor-pointer object-scale-down sm:mr-4 sm:max-h-[158px] sm:min-h-[158px] sm:w-[132px]`}
                      src={image.url}
                      alt={image.alt}
                      width={132}
                      height={158}
                    />
                  </Link>
                ))}
              </div>
              <div className="size-full">
                <Image
                  className="size-full object-scale-down object-center"
                  src={currentImage?.url ?? ""}
                  alt={currentImage?.alt ?? ""}
                  width={500}
                  height={500}
                />
              </div>
            </div>
          </div>
          <div className="flex-1">
            <div className="w-full bg-white">
              <div className="flex flex-col">
                <h1 className="break-words text-4xl font-medium text-[#4C4F52] md:text-[32px]">
                  {variant?.name}
                </h1>
                <div className="font-medium text-[#686C72]">
                  <DangerousSaleorRichText json={product.description} />
                </div>
                <div className="mt-4 font-medium text-[#686C72]">
                  <span>Üretim Süresi: </span>
                  <span>{`${productionTime.name ?? "30"} Gün`}</span>
                </div>
              </div>

              <div className="mt-4 flex gap-2">
                {
                  <div className="mt-1.5 text-[20px] font-medium text-[#4C4F52]">
                    {formatMoney(
                      variant?.pricing?.price?.gross.amount ?? 0,
                      variant?.pricing?.price?.gross.currency ?? "TRY"
                    )}
                  </div>
                }
              </div>

              <div className="flex items-end gap-x-5">
                <div className="flex flex-col">
                  <div className="mt-5 font-medium text-[#4C4F52]">Adet :</div>
                  <div className="mt-3 flex  max-w-full items-center gap-2">
                    <div className="flex h-10 w-[72px] items-center justify-center rounded border border-[#CFD1D2] font-medium text-[#252627]">
                      {pageState.quantity}
                    </div>
                    <div className="flex flex-col">
                      <Link
                        replace
                        shallow
                        scroll={false}
                        aria-disabled={pageState.quantity >= 50}
                        className="aria-disabled:cursor-not-allowed aria-disabled:text-[#ADB0B3]"
                        href={
                          pageState.quantity >= 50
                            ? "#"
                            : createStateLink(pageState, {
                                quantity: pageState.quantity + 1,
                              })
                        }
                      >
                        <ChevronUpIcon />
                      </Link>
                      <Link
                        replace
                        shallow
                        scroll={false}
                        aria-disabled={pageState.quantity <= 1}
                        className="aria-disabled:cursor-not-allowed aria-disabled:text-[#ADB0B3]"
                        href={
                          pageState.quantity <= 1
                            ? "#"
                            : createStateLink(pageState, {
                                quantity: pageState.quantity - 1,
                              })
                        }
                      >
                        <ChevronDownIcon />
                      </Link>
                    </div>
                  </div>
                </div>

                {/* <AddToCartButton
                  disabled={!isAvailable}
                  productId={product.id}
                  variantId={variant?.id}
                  quantity={pageState.quantity}
                  cartela={selectedCartela?.slug}
                /> */}
              </div>
            </div>
          </div>
        </div>
        <div>
          <ProductInfo
            title={product.name}
            stockCode={stockCode}
            productSize={productDimensions.name ?? "00x00x00"}
            warranty={`${warrantyTime.name ?? "36"} Ay`}
            pageState={pageState}
            canonicalPath={product.internalMeta.canonicalPath}
            cartela={cartela}
            productInformation={
              productInformation.richText ? (
                <DangerousSaleorRichText json={productInformation.richText} />
              ) : (
                "Teknik bilgi yok"
              )
            }
            technicalInformation={
              technicalInformation.richText ? (
                <DangerousSaleorRichText json={technicalInformation.richText} />
              ) : (
                "Teknik bilgi yok"
              )
            }
            productWeight={`${productWeight.name ?? ""} kg`}
          />
        </div>
      </div>
    </>
  );
}
