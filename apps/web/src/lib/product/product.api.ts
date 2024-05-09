import { createShopBreadcrumbs, isPresent } from "@w3yz/tools/lib";
import {
  useProductListByCategoryQuery,
  useProductListQuery,
  type SaleorGraphql_ProductListItemFragment,
} from "@w3yz/ecom/api";
import {
  useProductDetailsQuery,
  useProductVariantDetailsQuery,
} from "@w3yz/ecom/api";

export async function fetchProductDetails(id: string) {
  const response = await useProductDetailsQuery.fetcher({
    id: decodeURIComponent(id),
  })();

  const product = response.product;

  if (!product) return;

  const allCategories =
    [
      ...(product.category?.ancestors?.edges.map(({ node }) => node) ?? []),
      product.category,
    ]
      .map((cat) => {
        if (!cat?.id || !cat?.slug || !cat?.name) return;

        return {
          id: cat.id,
          slug: cat.slug,
          name: cat.name,
        };
      })
      .filter(isPresent) ?? [];

  const breadcrumbs = createShopBreadcrumbs([
    ...allCategories,
    {
      name: product.name,
      slug: product.slug,
    },
  ]);

  const canonicalPath = breadcrumbs.at(-1)?.canonicalPath ?? "";

  return {
    ...product,
    internalMeta: {
      allCategories,
      breadcrumbs,
      canonicalPath,
    },
  };
}
export async function fetchProductVariantDetails(id?: string) {
  const response = await useProductVariantDetailsQuery.fetcher({
    id: id ?? "",
  })();

  return response.productVariant;
}

export type DetailedProductType = Awaited<
  ReturnType<typeof fetchProductDetails>
>;

export type DetailedProductVariantType = Awaited<
  ReturnType<typeof fetchProductVariantDetails>
>;

export function mapProduct(product: SaleorGraphql_ProductListItemFragment) {
  const allCategories =
    [
      ...(product.category?.ancestors?.edges.map(({ node }) => node) ?? []),
      product.category,
    ]
      .map((cat) => {
        if (!cat?.id || !cat?.slug || !cat?.name) return;

        return {
          id: cat.id,
          slug: cat.slug,
          name: cat.name,
        };
      })
      .filter(isPresent) ?? [];

  const breadcrumbs = createShopBreadcrumbs([
    ...allCategories,
    {
      name: product.name,
      slug: product.slug,
    },
  ]);

  const canonicalPath = breadcrumbs.at(-1)?.canonicalPath ?? "";
  const internalMeta = {
    allCategories,
    breadcrumbs,
    canonicalPath,
  };

  return {
    ...product,
    internalMeta,
  };
}

export async function getProductsByCategory(categorySlug: "all" | string) {
  if (categorySlug === "all") {
    const response = await useProductListQuery.fetcher({
      first: 100,
    })();

    const products =
      response?.products?.edges?.map((edge) => mapProduct(edge.node)) ?? [];

    return {
      category: undefined,
      products,
    };
  }

  const response = await useProductListByCategoryQuery.fetcher({
    slug: categorySlug,
  })();

  if (!response.category?.name) {
    return;
  }

  const category = response.category;
  const products =
    response?.category?.products?.edges?.map((edge) => mapProduct(edge.node)) ??
    [];

  return {
    category,
    products,
  };
}
