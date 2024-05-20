import Image from "next/image";
import { useState } from "react";

export function FilterBox({ filterContent, filterBox, setFilterBox }: any) {
  const [dropdown, setDropdown] = useState<any>(false);

  // FIXME: Investigate this and remove if not neeeded
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const [selected, setSelected] = useState<any>([]);

  return (
    <section
      className={`w-full h-screen fixed z-50 ${
        filterBox ? "right-0" : "-right-full"
      } top-0 bg-[rgba(70,_76,_94,_0.6)] transition-[2s] overflow-y-auto`}
    >
      <div className="ml-auto w-[460px] min-h-screen bg-white">
        <div className="p-6 border-b border-[#EAECF0]">
          <label className="flex justify-between items-center mb-1 text-[#101828] text-[18px] font-semibold">
            Filtreler
            <button
              className="border-none outline-none bg-transparent"
              onClick={() => setFilterBox(false)}
            >
              <Image
                src={"/assets/xB.svg"}
                width={24}
                height={24}
                alt=""
                style={{
                  maxWidth: "100%",
                  height: "auto",
                }}
              />
            </button>
          </label>
          <p className="text-[#475467] text-[14px]">
            Sipariş verilerine filtre uygulayın.
          </p>
        </div>

        <div className="p-6 pb-4 mb-4 flex items-center relative">
          <input
            type="text"
            placeholder="Filtrelerde Ara"
            className="placeholder:text-[#464C5E] text-[14px] text-[#101828] w-full outline-none border border-[#D7DAE0] rounded-lg px-4 py-[10px] pl-10"
          />
          <Image
            src={"/assets/search.svg"}
            width={20}
            height={20}
            alt=""
            className="absolute ml-4"
            style={{
              maxWidth: "100%",
              height: "auto",
            }}
          />
        </div>

        <ul>
          {filterContent?.map((item: any, index: number) => (
            <li key={index}>
              <button
                type="button"
                className={`outline-none bg-transparent w-full flex items-center justify-between ${
                  dropdown === index ? "text-[#3670FB]" : "text-black"
                }  font-semibold px-6 py-4`}
                onClick={() => setDropdown(dropdown === index ? false : index)}
              >
                {item.label}

                <Image
                  src={
                    dropdown === index
                      ? "/assets/chevron-up.svg"
                      : "/assets/chevron-down.svg"
                  }
                  width={20}
                  height={20}
                  alt=""
                  style={{
                    maxWidth: "100%",
                    height: "auto",
                  }}
                />
              </button>

              <ul className={`${dropdown === index ? "block" : "hidden"}`}>
                {item.content.map((item: string, index: number) => (
                  <li key={index}>
                    <label
                      className={`flex items-center gap-x-[6px] cursor-pointer select-none text-[#464C5E] text-[14px] px-6 py-4 hover:bg-[#EFF5FF] hover:text-[#183ADD]`}
                    >
                      <input
                        type="checkbox"
                        width={20}
                        height={20}
                        onChange={(event: any) => {
                          event.target.checked
                            ? setSelected((old: any) => [...old, item])
                            : setSelected((old: any) => [...old, item]);
                        }}
                      />
                      <p dangerouslySetInnerHTML={{ __html: item }} />
                    </label>
                  </li>
                ))}
              </ul>
            </li>
          ))}
        </ul>
      </div>
    </section>
  );
}
