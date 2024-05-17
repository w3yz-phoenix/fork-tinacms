import { defineTinaTemplate } from "../../lib/tina.utils";

export const fashionStripBlockDefaultItem = {
  title: "Fashion Strip",
  text: "See our latest collection of fashion items.",
};

export const fashionStripBlockSchema = defineTinaTemplate({
  name: "fashionStrip",
  label: "Fashion Strip",
  ui: {
    previewSrc: "/blocks/fashion-strip/preview.png",
    defaultItem: {
      strip:
        "Amacımız kadınların günlük hayatlarında ve özel günlerde kendilerini en iyi hissetmelerini sağlayacak giyim çözümleri sunmaktır. Fashion, kaliteli ve şık giysileri erişilebilir fiyatlarla sunarak, müşteri memnuniyetini en üst düzeyde tutar.",
      author: "Fashion Ekibi",
    },
  },
  fields: [
    {
      type: "string",
      name: "strip",
      label: "Strip",
      isTitle: true,
      required: true,
    },
    {
      type: "string",
      name: "author",
      label: "author",
    },
  ],
});
