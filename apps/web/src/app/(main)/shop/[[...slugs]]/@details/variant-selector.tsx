"use server";

import Image from "next/image";
import Link from "next/link";
import { invariant } from "ts-invariant";

import { graphql } from "@/gql";
import { executeGraphQL } from "@/lib/graphql";
import { cn, isPresent } from "@/zivella-ui/lib";

import {
  getProductStateLinkGenerator,
  type ProductPageStateType,
} from "./common";
import {
  fetchAvailableCartelaChoices,
  fetchProductDetails,
} from "./product-data/product.api";
import { VariantDrawer } from "./variant-drawer";

const placeholderImagePath = "/images/loading.svg";

const VariantSelectionDetailsQuery = graphql(`
  query VariantSelectionDetails($productId: ID!, $selectedVariantId: ID!) {
    product(channel: "tr", id: $productId) {
      id
      name
      variants {
        id
        name
        quantityAvailable
        attributes(variantSelection: VARIANT_SELECTION) {
          attribute {
            slug
          }
          values {
            slug
            name
          }
        }
      }
    }

    referenceVariantForAttributes: productVariant(
      channel: "tr"
      id: $selectedVariantId
    ) {
      attributes(variantSelection: VARIANT_SELECTION) {
        attribute {
          slug
          name
          inputType
          withChoices
          choices(first: 100) {
            edges {
              node {
                slug
                name
              }
            }
          }
        }
      }
    }
  }
`);

const fetchVariantSelectionDetails = async (
  productId: string,
  selectedVariantId: string
) => {
  const response = await executeGraphQL(VariantSelectionDetailsQuery, {
    variables: {
      productId,
      selectedVariantId,
    },
  });

  return response;
};

export const VariantSelector = async (props: {
  pageState: ProductPageStateType;
  productId: string;
  selectedVariantId: string;
}) => {
  const variantData = await fetchVariantSelectionDetails(
    props.productId,
    props.selectedVariantId
  );

  if (
    !variantData?.product?.id ||
    variantData?.referenceVariantForAttributes?.attributes.length === 0
  ) {
    return;
  }

  invariant(variantData?.product?.id, "Product not found");
  invariant(
    variantData?.referenceVariantForAttributes?.attributes?.length,
    "Product variant not found"
  );

  const response = await fetchProductDetails(variantData.product.id);

  invariant(response?.id, "Product not found");
  const { internalMeta, cartelaImage } = response;

  const cartelaInfo = cartelaImage?.values[0];

  const availableCartelaChoices = cartelaInfo
    ? await fetchAvailableCartelaChoices(cartelaInfo?.slug ?? "")
    : [];

  const selectedCartela =
    availableCartelaChoices.find((c) => c.slug === props.pageState.cartela) ??
    availableCartelaChoices[0];

  const createStateLink = getProductStateLinkGenerator(
    internalMeta.canonicalPath
  );

  const { product, referenceVariantForAttributes } = variantData;

  const availableAttributes = referenceVariantForAttributes.attributes
    .map((a) => a.attribute)
    .filter((currentAttribute) => {
      const variantsWithThisAttributeProvided =
        product.variants?.filter((v) =>
          v.attributes.find(
            (a) =>
              a.attribute.slug === currentAttribute.slug && a.values.length > 0
          )
        ) ?? [];

      return variantsWithThisAttributeProvided.length > 0;
    });

  const variantsWithAvailableAttributes =
    product.variants?.filter((v) =>
      v.attributes?.find(
        (a) =>
          availableAttributes.find((b) => a.attribute.slug === b.slug) &&
          a.values.length > 0
      )
    ) ?? [];

  const selectedVariant = product.variants?.find(
    (v) => v.id === props.selectedVariantId
  );

  const otherVariants = variantsWithAvailableAttributes.filter(
    (v) => v.id !== props.selectedVariantId
  );

  if (otherVariants.length <= 0 && availableCartelaChoices.length <= 0) {
    return;
  }

  const attributeData =
    availableAttributes
      .map((attribute) => {
        const title = attribute.name;
        const slug = attribute.slug;
        const choices =
          attribute.choices?.edges
            .map((choice) => {
              if (
                product.variants?.find((v) =>
                  v.attributes.find(
                    (a) =>
                      a.attribute.slug === attribute.slug &&
                      a.values.find((v) => v.slug === choice.node.slug)
                  )
                ) === undefined
              ) {
                return;
              }

              const variantsWithThisChoice = otherVariants?.filter((v) =>
                v.attributes?.find((a) =>
                  a.values?.find((v) => v.slug === choice.node.slug)
                )
              );

              const availableVariants = variantsWithThisChoice?.sort((a, b) => {
                const aMatchCount = a.attributes?.filter((a) =>
                  a.values?.find((v) =>
                    selectedVariant?.attributes
                      ?.find(
                        (selectedAttribute) =>
                          selectedAttribute.attribute.slug === a.attribute.slug
                      )
                      ?.values?.find(
                        (selectedValue) => selectedValue.slug === v.slug
                      )
                  )
                ).length;

                const bMatchCount = b.attributes?.filter((a) =>
                  a.values?.find((v) =>
                    selectedVariant?.attributes
                      ?.find(
                        (selectedAttribute) =>
                          selectedAttribute.attribute.slug === a.attribute.slug
                      )
                      ?.values?.find(
                        (selectedValue) => selectedValue.slug === v.slug
                      )
                  )
                ).length;

                return bMatchCount - aMatchCount;
              });

              const isSelected = Boolean(
                selectedVariant?.attributes
                  ?.find((a) => a.attribute.slug === attribute.slug)
                  ?.values?.find((v) => v.slug === choice.node.slug) ?? false
              );

              const variantToSelect = isSelected
                ? selectedVariant
                : availableVariants?.[0];

              const isAvailable = Boolean(
                variantToSelect?.id &&
                  variantToSelect?.quantityAvailable &&
                  variantToSelect?.quantityAvailable > 0
              );

              const href =
                isAvailable && !isSelected && availableVariants?.[0]
                  ? createStateLink(props.pageState, {
                      variant: availableVariants?.[0].id,
                    })
                  : "#";

              const variantStyles = {
                default:
                  "text-center px-[16px] py-[10px] cursor-default rounded text-[#4C4F52] bg-white border border-[#CFD1D2]",
                selected:
                  "bg-[#F5F6F6] border-[#ADB0B3] text-[#4C4F52] cursor-default",
                disabled:
                  "cursor-not-allowed bg-white text-[#E5E6E8] border-[#E5E6E8]",
                available:
                  "cursor-pointer hover:bg-[#F5F6F6] hover:text-[#4C4F52] hover:border-[#ADB0B3]",
              };

              return (
                <>
                  <div className="group/popper relative">
                    {!isAvailable && (
                      <div className="absolute bottom-[35px]  hidden w-[140px] whitespace-nowrap rounded-lg border border-[#EC8065] py-1.5 text-center text-sm text-[#EC8065] group-hover/popper:block">
                        Ürün stokta yok
                      </div>
                    )}
                    <Link
                      replace
                      shallow
                      scroll={false}
                      key={choice.node.slug}
                      href={href}
                      className={cn([
                        "cursor-not-allowed ",
                        variantStyles.default,
                        isAvailable
                          ? variantStyles.available
                          : variantStyles.disabled,
                        isSelected && variantStyles.selected,
                      ])}
                    >
                      {choice.node.name}
                    </Link>
                  </div>
                </>
              );
            })
            ?.filter(isPresent) ?? [];

        if (choices.length < 2) {
          return;
        }

        return {
          title,
          slug,
          choices,
        };
      })
      ?.filter(isPresent) ?? [];

  return (
    <div className="flex flex-1 flex-col gap-8">
      {props.pageState.cartelaDrawer && (
        <VariantDrawer
          canonicalPath={internalMeta.canonicalPath}
          pageState={props.pageState}
          choices={availableCartelaChoices}
        />
      )}
      {availableCartelaChoices.length > 0 && (
        <div className="flex max-w-[542px] flex-col">
          <div className="text-[16px] font-medium text-[#4C4F52]">
            Renk Seçenekleri
          </div>
          <div className="mt-[12px] flex flex-wrap gap-3 text-[12px] font-normal">
            {selectedCartela &&
              (() => {
                const variantStyles = {
                  default:
                    "text-center px-[10px] py-[5px] cursor-default rounded text-[#4C4F52] bg-white border border-[#CFD1D2]",
                  disabled:
                    "cursor-not-allowed bg-white text-[#E5E6E8] border-[#E5E6E8]",
                  available:
                    "cursor-pointer hover:bg-[#F5F6F6] hover:text-[#4C4F52] hover:border-[#ADB0B3]",
                };

                return (
                  <Link
                    replace
                    shallow
                    scroll={false}
                    key={selectedCartela.slug}
                    href={createStateLink(props.pageState, {
                      cartelaDrawer: true,
                    })}
                    className={cn([
                      "cursor-not-allowed",
                      variantStyles.default,
                      variantStyles.available,
                    ])}
                  >
                    <div className="mb-2">{selectedCartela.name}</div>
                    <Image
                      src={selectedCartela.file?.url ?? placeholderImagePath}
                      alt={selectedCartela.name ?? ""}
                      width={120}
                      height={100}
                      className="h-[40px]"
                    />
                  </Link>
                );
              })()}
          </div>
        </div>
      )}
      {attributeData.map(({ title, slug, choices }) => (
        <div className="flex max-w-[542px] flex-col" key={slug}>
          <div className="text-[16px] font-medium text-[#4C4F52]">{title}</div>
          <div className="mt-[12px] flex flex-wrap gap-3 text-[12px] font-normal">
            {choices.map((choice) => (
              <>{choice}</>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
};
