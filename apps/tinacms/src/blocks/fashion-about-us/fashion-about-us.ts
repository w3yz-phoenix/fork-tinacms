import { defineTinaTemplate } from "../../lib/tina.utils";

export const fashionAboutUsBlockDefaultItem = {
  title: "Hakkımızda",
  subTitleAboutUs: "Yıllar geçtikçe ilerleyen markamız, her geçen gün daha da büyüyen ve genişleyen bir aileye dönüştü.",
  imageAlt: "About Us",
  aboutUsTitle: "Misyonumuz, her bütçeye uygun, yüksek kaliteli ve trend giysiler sunarak, müşterilerimizin kendi tarzlarını yaratmalarına yardımcı olmaktır.",
  aboutUsText: "Koleksiyonlarımızda her zevke ve tarza hitap eden ürünler yer almaktadır. Elbiseler, pantolonlar, etekler, bluzlar, tişörtler, kazaklar, montlar ve aksesuarlar gibi geniş bir ürün yelpazesine sahibiz. Sürdürülebilir bir geleceğe katkıda bulunmak için, üretim süreçlerimizde çevreye duyarlı yöntemler kullanmaya özen gösteriyoruz.Ayrıca, geri dönüştürülmüş malzemelerden üretilmiş ürünler de sunuyoruz.",
  backGroundImage: "/blocks/fashion-about-us/backgroud.png",
  photoContent: "/blocks/fashion-about-us/contentImage.png",
};

export const FashionAboutUsBlockSchema = defineTinaTemplate({
  name: "FashionAboutUs",
  label: "Fashion About Us",
  ui: {
    previewSrc: "/blocks/fashion-about-us/preview.png",
    defaultItem: {
      ...fashionAboutUsBlockDefaultItem,
      items: [fashionAboutUsBlockDefaultItem],
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
      name: "subTitleAboutUs",
      label: "Sub Title",
      required: true,
    },
    {
      type: "image",
      name: "backGroundImage",
      label: "Background Image",
      required: true,
    },
    {
      type: "image",
      name: "photoContent",
      label: "Image",
      required: true,
    },
    {
      type: "string",
      name: "imageAlt",
      label: "Alt",
    },
    {
      type: "string",
      name: "aboutUsTitle",
      label: "About Us Title",
      required: true,
    },
    {
      type: "string",
      name: "aboutUsText",
      label: "About Us Text",
      required: true,
    },
  ],
});
