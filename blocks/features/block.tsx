import type { TinaGraphql_PageBlocksFeatures } from "@w3yz/gql-tina";
import { tinaField } from "@w3yz/ui-core";

export const Component = ({
  block,
}: {
  block: TinaGraphql_PageBlocksFeatures;
}) => {
  const { items } = block;
  return (
    <section className="container mx-auto mt-14 grid grid-cols-2 gap-6 px-5 md:grid-cols-4">
      {items?.map((item, index) => {
        if (!item) return null;
        return (
          <div
            data-tina-field={tinaField(item)}
            key={index}
            className="mx-auto flex flex-col items-center text-center md:max-w-[216px]"
          >
            {/* <Image src={image} width={60} height={55} alt="" /> */}
            <label
              data-tina-field={tinaField(item, "title")}
              className="mb-3 mt-4 text-[16px] font-bold text-[#292929] lg:text-[20px]"
            >
              {item?.title}
            </label>
            <p
              data-tina-field={tinaField(item, "text")}
              className="text-[14px] text-[#656565] lg:text-[16px]"
            >
              {item?.text}
            </p>
          </div>
        );
      })}
    </section>
  );
};
