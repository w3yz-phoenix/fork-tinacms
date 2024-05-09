import Link from "next/link";

export default function NotFound() {
  return (
    <div className="flex min-h-[700px] w-full flex-col items-center justify-center bg-[#F5F6F6] lg:flex-row">
      <section className="flex max-w-7xl flex-col items-center justify-center p-8">
        <h1 className="mt-8 text-6xl font-bold text-neutral-900">Sepet Boş</h1>
        <p className="my-12 text-2xl text-neutral-500">
          Görünüşe göre sepetinize hiç ürün eklenmemiş.
        </p>
        <Link
          href="/shop"
          className="inline-block max-w-full rounded border border-transparent bg-neutral-900 px-6 py-3 text-center font-medium text-neutral-50 hover:bg-neutral-800 aria-disabled:cursor-not-allowed aria-disabled:bg-neutral-500 sm:px-16"
        >
          Alışverişe Devam Et
        </Link>
      </section>
    </div>
  );
}
