import { createShopBreadcrumbs, isPresent } from "@w3yz/tools/lib";
import {
  useProductListByCategoryQuery,
  useProductListQuery,
  type SaleorGraphql_ProductListItemFragment,
} from "@w3yz/ecom/api";

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
    })({ next: { revalidate: 60 } });

    const products =
      response?.products?.edges?.map((edge) => mapProduct(edge.node)) ?? [];

    return {
      category: undefined,
      products,
    };
  }

  const response = await useProductListByCategoryQuery.fetcher({
    slug: categorySlug,
  })({ next: { revalidate: 60 } });

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
