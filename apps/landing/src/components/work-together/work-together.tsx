import Link from "next/link";

export function WorkTogether() {
  return (
    <div
      className="mt-32 flex h-[450px] w-full flex-col items-center justify-center bg-[url('/assets/homepagetopfooter.jpg')] bg-cover bg-center bg-no-repeat max-lg:px-4"
      id="beraber-calisalim"
    >
      <p className="max-w-[804px] text-center text-[30px] font-semibold text-white md:text-[45px] lg:text-[64px]">
        E-Ticaretine başlamaya hazır mısın?
      </p>
      <Link
        href="/iletisim"
        className="mt-[30px] flex h-[60px] w-[200px] items-center justify-center rounded-lg border border-DEFAULT bg-white text-[24px] font-medium text-[#565E73] hover:border-[#8A94A6] hover:bg-[#F6F6F6] hover:text-[#24262D] hover:shadow-[0_0_0_2px_rgba(215,218,224,0.80)]"
      >
        Hemen Dene
      </Link>
    </div>
  );
}
