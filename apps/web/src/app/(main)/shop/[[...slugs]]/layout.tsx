import { notFound } from "next/navigation";
import { Suspense } from "react";

import { getShopPageData } from "../../../../lib/shop.api";

export default async function ShopCatchAllLayout(props: {
  params: { slugs?: string[] };
  details: React.ReactNode;
  list: React.ReactNode;
}) {
  const data = await getShopPageData(props.params.slugs);

  if (data.type === "not-found") {
    return notFound();
  }

  const showList = data.type === "all" || data.type === "category";
  const showDetails = data.type === "product";

  return (
    <>
      {showDetails && <Suspense>{props.details}</Suspense>}
      {showList && <Suspense>{props.list}</Suspense>}
    </>
  );
}
