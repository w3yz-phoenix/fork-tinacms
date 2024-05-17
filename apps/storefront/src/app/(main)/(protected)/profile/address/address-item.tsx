export function AddressItem() {
  return (
    <div>
      <label className="mb-2 block text-[15px] font-medium text-[#344054]">
        Ev
      </label>
      <div className="rounded border border-[#D0D5DD] bg-white p-5">
        <label className="mb-3 block text-[16px] font-medium text-[#667085]">
          Şeyda Aydoğdu
        </label>
        <div className="flex flex-col gap-[16px]">
          <p className="text-[14px] text-[#667085]">
            Atakent mahallesi 430 sokak no/1 daire 501
          </p>
          <p className="text-[14px] text-[#667085]">İdil/Şırnak</p>
          <p className="text-[14px] text-[#667085]">535*****67</p>
        </div>

        <div className="mt-6 flex gap-3">
          <button
            type="submit"
            className="flex h-11 w-full items-center justify-center gap-3 rounded bg-[#292929] px-7 text-white hover:bg-[#525252]"
          >
            Güncelle
          </button>
          <button
            type="submit"
            className="flex h-11 w-full items-center justify-center gap-3 rounded border border-[#BDBDBD] bg-[#FFF] px-7 text-[#464646]"
          >
            Sil
          </button>
        </div>
      </div>
    </div>
  );
}
