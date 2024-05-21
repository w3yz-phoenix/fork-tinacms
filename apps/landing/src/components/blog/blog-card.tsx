import Image from "next/image";
import Link from "next/link";

import { getImageUri } from "#landing/app/api/strapi/image";

export function BlogCard({ blogData }: any) {
  return (
    <div className="w-full mx-auto">
      <Link
        href={`/blog/${blogData?.attributes.slug}`}
        className="w-full mb-12"
      >
        <div className="h-[280px] w-full ">
          <Image
            src={getImageUri(
              blogData.attributes?.blogcardimage?.data?.attributes?.url
            )}
            alt=""
            height={280}
            width={405}
            className="object-cover size-full"
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
