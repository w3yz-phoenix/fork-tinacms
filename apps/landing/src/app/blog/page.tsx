import Head from "next/head";
import Link from "next/link";

import { getApiInstance } from "#landing/app/api/strapi/api";
import { BlogCard } from "#landing/components/blog/blog-card";

async function getData() {
  const api = getApiInstance();
  const response = await api.get("blog-posts", {
    params: {
      populate: "*",
    },
  });
  return response.data;
}

export default async function BlogList() {
  const blogData = await getData();

  return (
    <>
      <Head>
        <title>{blogData.data?.attributes?.seo?.metaTitle}</title>
      </Head>
      <div className="flex h-[200px] items-center justify-center bg-[#F6F6F6] ">
        <div className="text-center">
          <h1 className="mb-4 text-3xl font-bold text-[#292929] sm:text-4xl md:text-5xl xl:text-7xl">
            Blog
          </h1>
          <div className="text-sm text-[#989898] sm:text-lg md:text-lg xl:text-xl">
            <Link href="/">Ana Sayfa / </Link>
            <Link href="/blog">Blog / </Link>
            <span className="text-[#292929]">Seçili Kategori</span>
          </div>
        </div>
      </div>
      <div className="grid grid-cols-1 gap-8 px-5 my-20 sm:px-10 lg:mx-auto max-w-screen-2xl justify-items-center lg:grid-cols-2 xl:grid-cols-3">
        {blogData.data?.map((blog: any, index: number) => (
          <BlogCard blogData={blog} key={index} />
        ))}
      </div>
    </>
  );
}
