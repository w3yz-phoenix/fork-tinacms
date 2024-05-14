import Image from "next/image";
import Link from "next/link";

import { getImageUri } from "#landing/app/api/strapi/image";

export function BlogCard({ blogData }: any) {
  return (
    <div className="mx-auto w-full md:max-w-[361px]">
      <Link
        href={`/blog/${blogData?.attributes.slug}`}
        className="mb-12 w-full"
      >
        <div className="h-[280px] w-full md:max-w-[361px]">
          <Image
            src={getImageUri(
              blogData.attributes?.blogcardimage?.data?.attributes?.url
            )}
            alt=""
            height={280}
            width={405}
            className="size-full object-cover"
          />
        </div>
        <div className="mt-6 text-sm text-[#525252]">
          {blogData?.attributes.date}
        </div>
        <h5 className="mt-4 line-clamp-2 h-[54px] text-2xl text-[#292929]">
          {blogData.attributes.title}
        </h5>
        <p className="mt-3 line-clamp-4 text-lg text-[#656565]">
          {blogData.attributes.description}
        </p>
      </Link>
    </div>
  );
}
