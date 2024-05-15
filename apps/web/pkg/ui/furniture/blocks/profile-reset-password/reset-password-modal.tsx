import { useEffect, useRef } from "react";

export function ResetPasswordModal({ children, isOpen, setIsOpen }: any) {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(event: { target: any }) {
      if (ref.current && !ref.current.contains(event.target)) {
        setIsOpen(false);
      }
    }

    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [ref, setIsOpen]);

  return (
    <section
      className={`${isOpen ? "grid" : "hidden"} fixed left-0 top-0 z-0 h-screen w-full place-items-center bg-[rgba(0,_0,_0,_0.20)] p-5`}
    >
      <div
        className="z-50 w-full max-w-[644px] bg-white p-3 md:p-[72px]"
        ref={ref}
      >
        <div className="mb-10 flex flex-col justify-center gap-1 text-center">
          <label className="text-[20px] font-semibold text-[#101828]">
            Parola Yenileme
          </label>
          <p className="text-[16px] text-[#464C5E]">
            Parolanızı yenileyebilmeniz için size bir kod göndereceğiz.
          </p>
        </div>
        <form>
          {children}
          <div className="mt-8 w-full">
            <button
              className={
                "h-11 w-full rounded bg-[#292929] px-4 py-[7px] text-white hover:bg-[#525252] disabled:bg-[#DCDCDC]"
              }
              type="submit"
            >
              Kod Gönder
            </button>
          </div>
        </form>
      </div>
    </section>
  );
}
