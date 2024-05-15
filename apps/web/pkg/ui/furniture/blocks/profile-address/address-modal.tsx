import React from "react";

export function AddressModal({ modalShow, setModalShow }: any) {
  return (
    <section
      className={`fixed left-0 top-0 z-10 h-dvh w-screen place-items-center bg-[#53565A66] p-5 ${
        modalShow ? "grid" : "hidden"
      }`}
    >
      <div className="mx-auto h-[850px] max-h-[calc(100vh-80px)] w-full max-w-[933px] overflow-y-auto bg-white p-5 !py-0 sm:p-10">
        <div className="sticky top-0 z-50 flex flex-col items-center justify-center gap-5 bg-white pb-9 pt-10 sm:flex-row sm:justify-between">
          <div className="text-center sm:text-start">
            <label className="mb-3 block text-[30px] font-semibold text-[#292929]">
              Adres Ekle
            </label>
            <p className="text-[16px] text-[#656565]">
              Siparişleriniz için yeni adres ekleyin.
            </p>
          </div>
          <div className="flex items-center gap-9">
            <label className="flex cursor-pointer select-none items-center gap-2.5 text-[16px] font-medium text-[#989898]">
              <input
                type="radio"
                name="type"
                className="min-w-[20px] accent-[#656565]"
              />
              Bireysel
            </label>
            <label className="flex cursor-pointer select-none items-center gap-2.5 text-[16px] font-medium text-[#989898]">
              <input
                type="radio"
                name="type"
                className="min-w-[20px] accent-[#656565]"
              />
              Kurumsal
            </label>
          </div>
        </div>

        <form className="flex flex-col gap-5">
          <div className="flex flex-col gap-1.5">
            <label className="text-[12px] font-medium text-[#292929]">
              Adres Başlığı
            </label>
            <input
              className={
                "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
              }
              type={"text"}
              placeholder={"Ev,İş"}
            />
          </div>
          <div className="grid grid-cols-1 gap-5 sm:grid-cols-2">
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                Ad
              </label>
              <div className="relative z-0 w-full">
                <input
                  className={
                    "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                  }
                  type={"text"}
                  placeholder={"Ad"}
                />
              </div>
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                Soyad
              </label>
              <input
                className={
                  "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                }
                type={"text"}
                placeholder={"Soyad"}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                Telefon Numarası
              </label>
              <input
                className={
                  "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                }
                type={"text"}
                placeholder={"Telefon Numarası"}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                Ülke
              </label>
              <input
                className={
                  "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                }
                type={"text"}
                placeholder={"Ülke"}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                Şehir
              </label>
              <input
                className={
                  "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                }
                type={"text"}
                placeholder={"Şehir"}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                İlçe
              </label>
              <input
                className={
                  "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                }
                type={"text"}
                placeholder={"İlçe"}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                Mahalle
              </label>
              <input
                className={
                  "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                }
                type={"text"}
                placeholder={"Mahalle"}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <label className="text-[12px] font-medium text-[#292929]">
                Posta Kodu
              </label>
              <input
                className={
                  "w-full rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
                }
                type={"text"}
                placeholder={"Posta Kodu"}
              />
            </div>
          </div>
          <div className="flex flex-col gap-1.5">
            <label className="text-[12px] font-medium text-[#292929]">
              Açık Adres
            </label>
            <textarea
              className={
                "w-full resize-none rounded-lg border border-gray-300 px-4 py-3 text-gray-700 placeholder:text-gray-300 focus:border-green-500 focus:outline-none disabled:text-gray-200"
              }
              rows={3}
              placeholder={"Açık Adres"}
            />
          </div>
          <div className="sticky bottom-0 mt-6 flex w-full gap-3 bg-white pb-10 sm:justify-end">
            <button
              type="button"
              className="flex h-11 w-full items-center justify-center gap-3 rounded border border-[#BDBDBD] bg-[#FFF] px-7 text-[#464646] sm:max-w-fit"
              onClick={() => setModalShow(false)}
            >
              Vazgeç
            </button>
            <button
              type="submit"
              className="flex h-11 w-full items-center justify-center gap-3 rounded bg-[#292929] px-7 text-white hover:bg-[#525252] sm:max-w-fit"
            >
              Kaydet
            </button>
          </div>
        </form>
      </div>
    </section>
  );
}
