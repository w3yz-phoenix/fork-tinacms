import { imageField } from "../../fields/image";
import { linkField } from "../../fields/link";
import { defineTinaTemplate } from "../../lib/tina.utils";

export const seeCollectionDescBlockDefaultItem = {
  title: "See Collection",
  text: "See our latest collection of fashion items.",
};

export const seeCollectionDescBlockSchema = defineTinaTemplate({
  name: "seeCollectionDesc",
  label: "See Our Collection Descrption",
  ui: {
    previewSrc: "/blocks/fashion-see-collection-desc/preview.png",
    defaultItem: {
      title: "Yeni ve Modern",
      subTitle:
        "Yepyeni koleksiyonumuzla sizleri güneşli günlere hazırlamak için sabırsızlanıyoruz. Renkli elbiselerden göz alıcı aksesuarlara kadar her tarza hitap eden parçalarla gardırobunuzu yenilemenin tam zamanı!",
      linkTitle: "Koleksiyonu Gör",
      items: [seeCollectionDescBlockDefaultItem],
    },
  },
  fields: [
    {
      type: "string",
      name: "title",
      label: "Title",
      isTitle: true,
      required: true,
    },
    {
      type: "string",
      name: "subTitle",
      label: "subTitle",
      maxlength: 100,
    },
    {
      type: "object",
      name: "photos",
      label: "photos",
      list: true,
      ui: {
        min: 2,
        max: 2,
        itemProps: (item: any) => {
          return {
            label: item?.alt,
            key: item?.image,
          };
        },
        defaultItem: {
          ...seeCollectionDescBlockDefaultItem,
        },
      },
      fields: [imageField as any],
    },
    linkField as any,
  ],
});
