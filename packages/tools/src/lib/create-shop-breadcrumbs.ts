export const createShopBreadcrumbs = (
  items: {
    name: string;
    slug: string;
  }[]
) => {
  const breadcrumbParts = [
    {
      label: "Ürünler",
      partUriComponent: "shop",
    },
    ...items.map((item) => ({
      label: item.name,
      partUriComponent: item.slug,
    })),
  ];

  const breadcrumbs: { label: string; canonicalPath: string }[] = [];
  for (let index = 0; index < breadcrumbParts.length; index++) {
    breadcrumbs.push({
      label: breadcrumbParts[index].label,
      canonicalPath: `/${breadcrumbParts
        .slice(0, index + 1)
        .map((part) => encodeURIComponent(part.partUriComponent))
        .join("/")}`,
    });
  }

  return breadcrumbs;
};
