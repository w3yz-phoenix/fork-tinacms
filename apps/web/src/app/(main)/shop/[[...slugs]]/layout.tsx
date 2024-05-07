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

  return (
    <>
      {data.type === "product" ? (
        <Suspense>{props.details}</Suspense>
      ) : (
        props.details
      )}

      {data.type === "all" || data.type === "category" ? (
        <Suspense>{props.list}</Suspense>
      ) : (
        props.list
      )}
    </>
  );
}
