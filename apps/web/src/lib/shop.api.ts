import {
  useCategoryListBySlugQuery,
  useProductBySlugQuery,
} from "@w3yz/ecom/api";
import { invariant } from "@w3yz/tools/lib";

async function findProductBySlug(slug: string) {
  const response = await useProductBySlugQuery.fetcher({
    slug: decodeURIComponent(slug),
  })({
    next: {
      revalidate: 60,
    },
  });

  return response.product;
}

async function findCategoriesBySlug(slugs: string[]) {
  const response = await useCategoryListBySlugQuery.fetcher({
    slugs: slugs.map((s) => decodeURIComponent(s)),
  })({
    next: {
      revalidate: 60,
    },
  });

  return response.categories?.edges.map((edge) => edge.node) ?? [];
}

type ShopPageData =
  | {
      type: "product";
      product: Awaited<ReturnType<typeof findProductBySlug>>;
    }
  | {
      type: "category";
      categories: Awaited<ReturnType<typeof findCategoriesBySlug>>;
    }
  | {
      type: "all";
    }
  | {
      type: "not-found";
    };

export async function getShopPageData(slugs?: string[]): Promise<ShopPageData> {
  if (!slugs || slugs.length === 0) {
    return { type: "all" };
  }

  invariant(slugs.length > 0, "Slugs should not be empty");

  const product = await findProductBySlug(slugs?.at(-1) ?? "");

  if (product) {
    return { type: "product", product };
  }

  const categories = await findCategoriesBySlug(slugs);

  if (categories.length <= 0) {
    return { type: "not-found" };
  }

  const lastCategory = categories.at(-1);

  invariant(lastCategory, "Last category should exist");

  return {
    type: "category",
    categories,
  };
}
