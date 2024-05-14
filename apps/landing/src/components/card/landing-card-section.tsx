import { LandingCards } from "#landing/components/card/landing-cards";

const cardListTop = [
  {
    size: "large" as const,
    title: "Envanter Takibi",
    description:
      "Envanteri otomatik olarak takip edin veya harici API'lere yetki verin.",
    image: {
      path: "/assets/property-envanter-takibi.png",
      alt: "envanter takibi",
    },
  },
  {
    size: "small" as const,
    title: "Çoklu Depo Stoğu",
    description:
      "Birden fazla depo tanımlayın ve bu depolardaki ürün  stoklarınızı yönetin.",
    image: {
      path: "/assets/property-coklu-depo.png",
      alt: "coklu depo stogu",
    },
  },
  {
    size: "small" as const,
    title: "Stok limitleri",
    description:
      "Tek bir ödemede satın alınan miktarı sınırlamak için ürün başına bir stok sınırı belirleyin.",
    image: {
      path: "/assets/property-stok-limitleri.png",
      alt: "stok limitleri",
    },
  },
  {
    size: "horizontal" as const,
    title: "Vergiler",
    description: "Ürünlere vergi kategorilerini tanımlayın ve atayın.",
    image: { path: "/assets/property-vergiler.png", alt: "vegiler" },
  },
];
const cardListBottom = [
  {
    size: "large" as const,
    title: "Elektronik tablo arayüzü",
    description:
      "Envanteri otomatik olarak takip edin veya harici API'lere yetki verin.",
    image: {
      path: "/assets/property-elektronik-tablo.png",
      alt: "elektronik tablo arayüzü",
    },
  },
  {
    size: "small" as const,
    title: "Promosyon planla",
    description: "Promosyonları belirli saat ve tarihlere göre planlayın.",
    image: {
      path: "/assets/property-promosyon-planla.png",
      alt: "promosyon planla",
    },
  },
  {
    size: "small" as const,
    title: "Müşteri grupları",
    description:
      "Kuralları kullanarak promosyonları belirli müşterilere hedefleyin.",
    image: {
      path: "/assets/property-musteri-grupları.png",
      alt: "musteri grupları",
    },
  },
  {
    size: "horizontal" as const,
    title: "Ürün çeşitleri",
    description:
      "Ürün içeriğini, özelliklerini ekleyin ve stok durumunu varyant düzeyinde yönetin.",
    image: {
      path: "/assets/property-urun-cesitleri.png",
      alt: "urun cesitleri",
    },
  },
];
const cardListMiddle = [
  {
    size: "medium" as const,
    title: "Ülkeye Göre Para Birimi",
    description:
      "Müşterilerinizin tercih ettiği para birimiyle ürün fiyatlarını görüntülemesini sağlayın.",
    image: {
      path: "/assets/property-para-birimi.png",
      alt: "ulkeye gore para birimi",
    },
  },
  {
    size: "medium" as const,
    title: "Ürün listeleme",
    description:
      "Ürünlerin çeşitli kanallardaki listeleme ayarlarını kontrol edin.",
    image: {
      path: "/assets/property-urun-listeleme.png",
      alt: "urun listeleme",
    },
  },
  {
    size: "medium" as const,
    title: "Hediye Kartları",
    description:
      "Fiziksel veya sanal hediye kartları satın ve bunları müşteri kredisiyle ilişkilendirin.",
    image: {
      path: "/assets/property-hediye-kartlari.png",
      alt: "hediye kartlari",
    },
  },
  {
    size: "medium" as const,
    title: "Çeviriler",
    description:
      "Özellikler, koleksiyonlar ve adlar gibi ürünle ilgili tüm içeriği yerelleştirin.",
    image: { path: "/assets/property-ceviriler.png", alt: "ceviriler" },
  },
  {
    size: "medium" as const,
    title: "Çoklu kupon kodları",
    description:
      "Bir promosyon kampanyası için kupon kodlarını toplu olarak oluşturun ve yönetin.",
    image: {
      path: "/assets/property-coklu-kupon.png",
      alt: "coklu kupon kodları",
    },
  },
  {
    size: "medium" as const,
    title: "Sepet indirimleri ",
    description:
      "X satın al, Y kazan, ücretsiz gönderim ve çok daha fazlası gibi koşullu promosyonlar oluşturun.",
    image: {
      path: "/assets/property-sepet-indirimleri.png",
      alt: "sepet indirimleri",
    },
  },
];
export const LandingCardSection = () => {
  return (
    <div className="flex flex-col items-center justify-center gap-[70px] p-4">
      <div className=" text-center font-medium text-[#030711]">
        <p className="text-lg leading-tight">ÖZELLİKLER</p>
        <h3 className="mt-[5px] max-w-[826px] text-[28px] md:text-[64px] md:leading-[80px] ">
          Dinamik, içerik odaklı siteler oluşturun.
        </h3>
        <p className="mt-[22px] text-[16px] text-[#4B5563] md:text-3xl md:leading-loose">
          İşinizi en verimli şekilde organize etmek için sunduğumuz özelliklere
          göz atın.
        </p>
      </div>
      <LandingCards
        cardListTop={cardListTop}
        cardListMiddle={cardListMiddle}
        cardListBottom={cardListBottom}
      />
    </div>
  );
};
