import Image from "next/image";
import Link from "next/link";

import { getApiInstance } from "@/app/api/strapi/api";
import { getImageUri } from "@/app/api/strapi/image";

async function getData() {
  const api = getApiInstance();
  const response = await api.get("blog-posts", {
    params: {
      populate: ["subsubject.image.subimage, image"],
    },
  });

  return response.data;
}

export default async function BlogDetail({ params }: any) {
  const blogData = await getData();
  const blogDetails = blogData.data?.filter(
    (blog: any) => blog.attributes.slug === params.slug
  );
  const blogDetail = blogDetails[0].attributes;
  return (
    <div className="my-[180px]">
      <div className="relative h-[400px] w-full text-center">
        <Image
          src={getImageUri(blogDetail?.image?.data?.attributes?.url)}
          alt="blog"
          height={280}
          width={405}
          className="size-full object-cover"
        />
        <div className="absolute inset-0 bg-[#292929] opacity-50"></div>
        <div className="absolute left-1/2 top-1/2 z-10 -translate-x-1/2 -translate-y-1/2">
          <h1 className="mb-4 text-7xl text-[#D9D9D9]">Blog</h1>
          <div className="text-[#B3B9C6] ">
            <Link href="/">Ana Sayfa / </Link>
            <Link href="/blog">Blog / </Link>
            <span className="text-[#D9D9D9]">
              {blogDetail?.title?.slice(0, 30) + "..."}
            </span>
          </div>
        </div>
      </div>
      <div className="mx-auto mt-20 max-w-[916px]">
        <h3 className="mb-1 text-7xl text-[#292929]">{blogDetail?.title}</h3>
        <div className="flex items-center gap-2 font-light text-[656565]">
          <div>{blogDetail?.date}</div>
          <div className="size-2.5 rounded-full bg-[#656565]"></div>
          <div>{blogDetail?.author}</div>
        </div>
        <div className="mt-16 text-[#656565]">
          <p
            dangerouslySetInnerHTML={{
              __html: blogDetail?.description,
            }}
          ></p>

          {blogDetail?.subsubject?.map((sub: any, index: number) => (
            <div key={index}>
              <div
                className={`my-10 size-full ${
                  sub?.image?.length > 1
                    ? "grid grid-cols-1 gap-14 md:grid-cols-2"
                    : ""
                }`}
              >
                {sub.image &&
                  sub?.image?.map((img: any, index: number) => (
                    <div key={index}>
                      <Image
                        src={getImageUri(img?.subimage?.data?.attributes?.url)}
                        alt="blog"
                        height={515}
                        width={916}
                        className="size-full flex-1 object-cover"
                      />
                    </div>
                  ))}
              </div>
              {sub.subtitle && <p className="mb-5">{sub.subtitle}</p>}
              {sub.subdescription && (
                <p
                  dangerouslySetInnerHTML={{
                    __html: sub.subdescription,
                  }}
                ></p>
              )}
              {sub.highlight && (
                <div
                  className="mt-20 space-y-5 bg-[#F6F6F6] p-10 text-[21px] italic text-[#292929]"
                  dangerouslySetInnerHTML={{
                    __html: sub.highlight,
                  }}
                ></div>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
