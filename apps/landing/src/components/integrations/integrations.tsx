"use client";

import Image from "next/image";
import Link from "next/link";
import { useState } from "react";

import AkakceModal from "../../../public/assets/AkakceModal.svg";
import Akakcelogo from "../../../public/assets/Akakcelogo.png";
import AliExpress from "../../../public/assets/AliExpress.png";
import AliexpressModal from "../../../public/assets/AliexpressModal.svg";
import AmazonModal from "../../../public/assets/AmazonModal.svg";
import ChatGPT from "../../../public/assets/ChatGPT.svg";
import Etsy from "../../../public/assets/Etsy.png";
import EtsyModal from "../../../public/assets/EtsyModal.svg";
import Foreground from "../../../public/assets/Foreground.svg";
import ForegroundModal from "../../../public/assets/ForegroundModal.svg";
import googleAdsense from "../../../public/assets/Google-Adsense.png";
import GoogleAdsenseModal from "../../../public/assets/GoogleAdsenseModal.svg";
import GoogleAnalyticsModal from "../../../public/assets/GoogleAnalyticsModal.svg";
import GoogleDriveModal from "../../../public/assets/GoogleDriveModal.svg";
import GoogleMapsModal from "../../../public/assets/GoogleMapsModal.svg";
import InstaModal from "../../../public/assets/InstaModal.svg";
import MetaModal from "../../../public/assets/MetaModal.svg";
import N11Modal from "../../../public/assets/N11Modal.svg";
import N11Logo from "../../../public/assets/N11_logo.svg";
import TrendyolModal from "../../../public/assets/TrendyolModal.svg";
import adSense from "../../../public/assets/adSense.svg";
import amazon from "../../../public/assets/amazon.svg";
import appStoreModal from "../../../public/assets/appStoreModal.svg";
import appStore from "../../../public/assets/app_store.svg";
import chatGptModal from "../../../public/assets/chatGptModal.svg";
import cicekSepeti from "../../../public/assets/cicek-sepeti.png";
import ciceksepetiModal from "../../../public/assets/ciceksepetiModal.svg";
import elogo from "../../../public/assets/elogo.svg";
import elogoModal from "../../../public/assets/elogoModal.svg";
import fbMessenger from "../../../public/assets/fb_messenger.svg";
import gDrive from "../../../public/assets/g-drive.svg";
import googleMaps from "../../../public/assets/googleMaps.svg";
import hepsiburada from "../../../public/assets/hepsiburada.png";
import hepsiburadaModal from "../../../public/assets/hepsiburadaModal.svg";
import instagram from "../../../public/assets/instagram.svg";
import iyzico from "../../../public/assets/iyzico.svg";
import iyzicoModal from "../../../public/assets/iyzicoModal.svg";
import mesengerModal from "../../../public/assets/mesengerModal.svg";
import meta from "../../../public/assets/meta.svg";
import mng from "../../../public/assets/mng.png";
import mngModal from "../../../public/assets/mngModal.svg";
import parasut from "../../../public/assets/parasut.svg";
import payTr from "../../../public/assets/payTr.svg";
import paytrModal from "../../../public/assets/paytrModal.svg";
import prasutModal from "../../../public/assets/prasutModal.svg";
import pttKargo from "../../../public/assets/ptt-kargo.png";
import pttModal from "../../../public/assets/pttModal.svg";
import tiktok from "../../../public/assets/tiktok.svg";
import tiktokModal from "../../../public/assets/tiktokModal.svg";
import toplusmsLogo from "../../../public/assets/toplusmsLogo.png";
import toplusmsModal from "../../../public/assets/toplusmsModal.svg";
import trendyol from "../../../public/assets/trendyol.svg";
import whatsapp from "../../../public/assets/whatsapp.svg";
import whatsappModal from "../../../public/assets/whatsappModal.svg";
import youtube from "../../../public/assets/youtube.svg";
import youtubeModal from "../../../public/assets/youtubeModal.svg";

import { IntegrationsModal } from "./integrations-modal";

export function Integrations() {
  const [modalContent, setModalContent] = useState<any>({});
  const [isShow, setIsShow] = useState<boolean>(false);

  const modalHandler = (logo: any, title: string, description: string) => {
    setModalContent({ logo, title, description });
    setIsShow(true);
  };

  return (
    <section
      className="container mx-auto my-[180px] scroll-smooth px-5"
      id="ozelliklerimiz"
    >
      <div className="mb-12 flex flex-col gap-5">
        <div className=" lg:min-w-[750px]">
          <p className="mb-5 text-[14px] font-medium text-[#030711]">
            ENTEGRASYONLAR
          </p>
          <label className="text-[28px] font-medium text-[#030711] sm:text-[48px] lg:text-[64px]">
            Web sitenizi daha verimli bir hale getirin
          </label>
        </div>

        <div>
          <span className="mb-12 hidden lg:block"></span>
          <label className="mb-3 block text-xl font-medium text-[#333] sm:text-[22px]">
            Entegrasyon uygulamaları ile web sitenizi güçlendirin.
          </label>
          <p className=" text-xl text-[#030711] sm:text-[22px]">
            Web sitenizi daha ileri bir seviyeye taşımak için operasyonel
            işlemlerinizi otomatikleştiren entegrasyonları kullanabilirsiniz.
          </p>
        </div>
      </div>

      <div className="relative" id="integrationSection">
        <div className="grid grid-cols-4 gap-2 lg:grid-cols-6 lg:gap-4 xl:grid-cols-7">
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                AmazonModal,
                "Amazon mağazanızda listelediğiniz ürünleri kolayca sitenize görüntüleyin.",
                "Tek bir panel kullanarak ürün yükleme süreçlerinizi kolayca tamamlayabilir, tekil ürünlerinizi Amazon kataloğuna sorunsuz bir şekilde ekleyebilir ve aynı zamanda Amazon kataloğundaki ürünleri hızlıca eşleştirebilirsiniz. </br> </br> Siparişlerinizin kargo barkodlarını toplu bir şekilde yazdırabilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={amazon}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="amazon"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                MetaModal,
                "Sosyal medyada e-ticarete devam edin",
                "E-ticaret sitenizdeki tekil ve/veya seçenekli ürünleri belirli bir fiyat kuralına göre toplu bir şekilde Facebook Shop'a yükleyebilirsiniz. </br> </br> E-ticaret sitenizden gelen siparişlerin stok değişimleri anlık olarak Facebook Shop'ta da görüntülenebilir."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={meta}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="meta"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                InstaModal,
                "Instagram profil akışınız web sitenizde",
                "En çok kullanılan sosyal medya platformlarından biri olan Instagram'da sergilediğiniz görsellerinizinizi web sitenizin akışına ekleyebilirsiniz. Instagram üzerinden yapılan değişiklikler anlık olarak sitenizede aktarılır."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={instagram}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="instagram"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                GoogleAdsenseModal,
                "Web sitenizden gelir elde edin",
                "Google AdSense hesabınızı web sitenize entegre ederek sitenizde yayınlanan reklamlardan gelir elde edebilirisiniz. </br> </br> Web sitenizde görüntülenen reklamları yönetebilirisiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={googleAdsense}
                width={72}
                height={72}
                alt="googleAdsense"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                GoogleDriveModal,
                "Hızlı ve kolay bir şekilde dosyalarınızı paylaşın",
                "Web sitenizde Google Drive'daki dosyalarınızı ve klasörlerinizi doğrudan görüntüleyebilirsiniz. </br> </br> Sadece Microsoft Office ve PDF gibi formatları değil, aynı zamanda Google dosyalarını da sitenize entegre edebilirsiniz. </br> </br> Ziyaretçilerinize dosyalarınızı doğrudan web siteniz üzerinden görüntüleme ve düzenleme imkanı sunabilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={gDrive}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="gDrive"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                GoogleMapsModal,
                "Müşterilerinizle bağlantıda kalmanın en verimli ve kolay yolu.",
                "WhatsApp Business hesabınızı web sitenize entegre ederek müşterilerinize 7/24 kesintisiz destek sunabilirsiniz. </br> </br> İşletmenizin daha profesyonel ve etkin bir iletişim süreci yönetmesini sağlayabilirsiniz. </br> </br> Bu entegrasyon sayesinde web sitenize gelen mesajları kolayca görebilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={googleMaps}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="googleMaps"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                GoogleAnalyticsModal,
                "Google Analytics gücünden faydalanın",
                "Google Analytics hesabınız üzerinden takip ettiğiniz ziyaretçi verilerini, admin paneliniz üzerinde de Analytics entegrasyonu yaparak kolayca web sitenizde takip edebilirsiniz. </br> </br> İGelen ziyaretçilerinizin demografik özelliklerini, hangi ülkelerden veya şehirlerden geldiklerini görebileceğiniz gibi, ziyaretçilerinizin ekran çözünürlüklerini, hangi sitelerden yönlendirildiklerini ya da hangi anahtar kelimelerle arama motorlarında sitenize geldiklerini takip edebilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={adSense}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="adSense"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                whatsappModal,
                "Müşterilerinizle bağlantıda kalmanın en verimli ve kolay yolu.",
                "WhatsApp Business hesabınızı web sitenize entegre ederek müşterilerinize 7/24 kesintisiz destek sunabilirsiniz. </br> </br> İşletmenizin daha profesyonel ve etkin bir iletişim süreci yönetmesini sağlayabilirsiniz. </br> </br> Bu entegrasyon sayesinde web sitenize gelen mesajları kolayca görebilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={whatsapp}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="whatsapp"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                appStoreModal,
                "App Store yorumları ile güvenilirlik kazanın",
                "App Store üzerinden gelen yorumlarınızı anlık olarak web sitenizde görüntüleyebilirsiniz. </br> </br> Sadece görüntülemek istediğiniz yorumları seçebilir, öne çıkarabilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={appStore}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="appStore"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                mesengerModal,
                "Müşteriniz ile iletişimde kalın",
                "Web sitenize eklenen Messenger ikonu ile müşterileriniz tek tıkla size ulaşabilir. </br> </br> Messenger üzerinden gelen bu mesajları kolayca görüntüleyebilir, cevaplayabilir ve potansiyel müşterilerinizle iletişimde kalabilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={fbMessenger}
                width={72}
                height={72}
                alt="fbMessenger"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                youtubeModal,
                "YouTube içerikleriniz web sitenizde",
                "YouTube üzerinden üretmiş olduğunuz video içeriklerini web sitenizde dilediğiniz gibi görüntüleyebilirsiniz. </br> </br> İçeriklerinize web site ziyaretçileriniz kolayca erişim sağlayabilir ve onları YouTube profilinize yönlendirebilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={youtube}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="youtube"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                paytrModal,
                "Ödeme güvenliği ve ertesi gün ödeme avantajından yararlanabilmek için PayTR Sanal POS entegrasyonunu kullanabilirsiniz.",
                "Entegrasyonu tamamladıktan sonra satış yapmaya hemen başlayabilir ve anında ödeme alabilirsiniz.  </br> </br> Geleneksel yöntemlere veda ederek link ile ödeme alabilir bu sayede kolayca ödeme alarak işletmenizin verimliliğini ve güvenilirliğini artırabilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={payTr}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="payTr"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                iyzicoModal,
                "Birçok farklı para birimi ile kolayca ödeme alın",
                "Ödemelerinizi güvenli bir şekilde alın ayrıca iptal ve iade süreçlerinin kolaylığından faydalanın. </br> </br> Alışveriş adımlarını daha pratik ve kolay bir hale getirin. </br> </br> 7/24 canlı destek hizmetiyle sorularınızı ve sorunlarınızı kısa sürede çözüme kavuşturun."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={iyzico}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="iyzico"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                mngModal,
                "Kargo süreçlerinde zaman tasarrufu sağlayın",
                "E-ticaret sitenize gelen siparişleriniz için tek tıkla kargo barkodları oluşturabilirsiniz. </br> </br> Siparişlerinizin kargo barkolarını anlaşmalı olduğunuz MNG acentesine aktarabilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={mng}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="mng"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                elogoModal,
                "Kargo süreçlerinizi kolaylaştırın",
                "WhatsApp Business hesabınızı web sitenize entegre ederek müşterilerinize 7/24 kesintisiz destek sunabilirsiniz. </br> </br> İşletmenizin daha profesyonel ve etkin bir iletişim süreci yönetmesini sağlayabilirsiniz. </br> </br> Bu entegrasyon sayesinde web sitenize gelen mesajları kolayca görebilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={elogo}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="elogo"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                pttModal,
                "Kargo süreçlerinizi kolaylaştırın",
                "Vakit kaybetmeden gelen siparişlerinizin barkodlarını otomatik oluşturabilirsiniz. </br> </br> Gelen siparişlerinizin bilgileri PTT kargo hesabınıza aktarılır, siparişin bilgilerini çekerek otomatik oluşturulan barkod ile tek tıkla kargo fişi çıkarabilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={pttKargo}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="pttKargo"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                ForegroundModal,
                "Kargolama işlemlerinizi otomatikleştirin",
                "Gelen siparişlerinizin barkodlarını otomatik oluşturabilirsiniz. </br> </br> Gelen siparişlerinizin bilgileri Yurtiçi kargo hesabınıza aktarılır, siparişin bilgilerini çekerek otomatik oluşturulan barkod ile tek tıkla kargo fişi çıkarabilirsiniz. Kargolama işlemi sonrası kargonuzu şubeye teslim edebilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={Foreground}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="Foreground"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                TrendyolModal,
                "Trendyol satışlarınızı kontrol edin",
                "Trendyol entegrasyonu ile ürün, sipariş, stok, fatura ve kargo süreçlerinizi yönetebilirsiniz. </br> </br> Ürün yükleme işlemlerinizi tek panel üzerinden hızlı ve kolay bir şekilde gerçekleştirebilirsiniz. </br> </br> Trendyol kataloğunuzdaki ürünler ile e-ticaret sitenizdeki ürünleri kolaylıkla eşleştirebilirsiniz. </br> </br> Trendyol'dan gelen siparişlerinizin kargo fişi ve barkod işlemlerini yapabilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={trendyol}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="trendyol"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                hepsiburadaModal,
                "Hepsiburada entegrasyonu ile siparişlerinizi tek bir panelden yönetin!",
                " Ürünlerinizi kolayca yükleyin ve operasyonel süreçklerinizi tek bir panel üzerinden gerçekleştirebilirsiniz. </br> </br> Ürün, sipariş, stok ve kargo süreçlerinizi sorunsuz bir şekilde yönetebilirsiniz. </br> </br> Tedarikçi XML ürün kaynaklarınızdan gelen ürünleri toplu bir şekilde Hepsiburada'ya yükleyebilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={hepsiburada}
                width={72}
                height={72}
                alt="hepsiburada"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                N11Modal,
                "N11 entegrasyonu ile operasyonel süreçlerinizi kolaylaştırın.",
                "N11 pazaryerine ve kendi e-ticaret sitenize ürün yükleme sürecinizi tek bir panel üzerinden kolayca yönetebilirsiniz. </br> </br> Ürün, sipariş, stok ve kargo süreçlerinizi sorunsuz bir şekilde yönetebilirsiniz. </br> </br> E-fatura süreçlerinizi toplu bir şekilde yönetebilirsiniz. </br> </br> N11 kataloğunda bulunan ürünleri kolayca eşleştirebilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={N11Logo}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="N11Logo"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                toplusmsModal,
                "Müşterilerinizle iletişiminizi güncel tutmak için programlanabilir ve raporlanabilir özelliğe sahip Toplusms entegrasyonunu kullanın.",
                "TopluSMS entegrasyonu ile mesajınızı yüzlerce müşterinize eş zamanlı olarak ulaştırabilirsiniz. </br> </br> Bu entegrasyon sayesinde tanıtım bildirimlerini, güncellemeleri, kampanyaları ve iletmek istediğiniz mesajları müşterilerinizle kolayca buluşturabilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={toplusmsLogo}
                width={72}
                height={72}
                alt="toplusmsLogo"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                chatGptModal,
                "ChatGPT ile e-ticaret operasyonlarınızın sınırlarını zorlayın",
                "Ayrıntılı ve bilgilendirici bir açıklama, güvenilirliği artırır ve müşterilerinizi satın almaya teşvik eder. </br> </br> ChatGPT’ye ek ayrıntılar vererek ürün açıklamanızı iyileştirmesini isteyebilirsiniz. </br> </br> Ürününüzün temel özelliklerini anlatan, kullanıcı dostu bir metin oluşturması saniyeler alacaktır."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={ChatGPT}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="ChatGPT"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                tiktokModal,
                "Yeni nesil içerikleriniz web sitenizde",
                "Dünya üzerinde milyonlarda kullanıcıya sahip sosyal medya uygulaması TikTok artık markalar için bir vazgeçmez haline geliyor. </br> </br> Markanız, işletmeniz ve kişisel hesabınızdan yayınladığınız içerikleri bir akış halinde web sitenizde görüntüleyebilirsiniz. Böylece TikTok için etkileşim çekebilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={tiktok}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="tiktok"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                ciceksepetiModal,
                "Çiçeksepeti pazaryerinde öne çıkın",
                "Çiçeksepeti entegrasyonu ile ürün, sipariş, stok, fatura ve kargo süreçlerinizi yönetebilirsiniz. </br> </br> Ürün yükleme işlemlerinizi tek panel üzerinden hızlı ve kolay bir şekilde gerçekleştirebilirsiniz. </br> </br> Çiçeksepeti kataloğunuzdaki ürünler ile e-ticaret sitenizdeki ürünleri kolaylıkla eşleştirebilirsiniz. </br> </br> Çiçeksepeti'den gelen siparişlerinizin kargo fişi ve barkod işlemlerini yapabilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={cicekSepeti}
                width={72}
                height={72}
                alt="cicekSepeti"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                AliexpressModal,
                "Aliexpress entegrasyonu ile siparişlerinizi tek panelden yönetin!",
                "Ürün, sipariş, stok, fatura ve kargo süreçlerinizi kolayca takip edebilirsiniz. </br> </br> Aliexpress pazaryerine ve kendi e-ticaret sitenize ürün yükleme sürecinizi tek bir panel üzerinden kolayca yönetebilirsiniz. </br> </br> Aliexpress'den gelen siparişlerinizin kargo fişi ve barkod işlemlerini yapabilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={AliExpress}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="AliExpress"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                EtsyModal,
                "Yurtdışı pazarında yer edinin",
                "Satışını yaptığınız ürünlerde renk, beden, ölçü vb seçenekler varsa bu tür ürünleri  Etsy'ye kolayca gönderebilirsiniz. Tekli veya varyatlı ürünlerinizi websitenizde ki ürünlerle eşleştirebilirsiniz. </br> </br> Stoklarınız anlık olarak güncellenir böylece stok kontolleriniz otomatikleştirmiş olursunuz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={Etsy}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="Etsy"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                AkakceModal,
                "Ürün yükleme, stok güncelleme, faturalandırma, kargolama süreçlerini otomatik gerçekleştirin",
                "Web sitenizdeki ürünlerinizi toplu olarak Akakçe'ye gönderebilirsiniz. </br> </br> Ürün ve stok bilgileriniz otomatik olarak güncellenir. </br> </br> Akakçe'den aldığınız siparişlerle birlikte platform, satıcı, alıcı, kampanya kodu ve barkod bilgileriyle birlikte kargo etiketi otomatik olarak oluşturulur bu etiketi ister tek tek ister toplu olarak yazdırabilirsiniz. </br> </br> Akakçe'den gelen siparişlerle birlikte her siparişte müşteri, ürün, tutar, kargo, vergi ve varsa vade farkı bilgileriyle birlikte faturanız otomatik olarak oluşturulur."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={Akakcelogo}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="Akakcelogo"
              />
            </div>
          </Link>
          <Link
            href={"#integrationSection"}
            className="grid w-full cursor-pointer select-none place-content-center rounded-lg border border-[#EDE8FF] bg-[linear-gradient(180deg,_#F7F2FF_0%,_#FAF7FF_65.54%,_#FFF_100%)] p-5 transition-all hover:border-[#9153FF] hover:shadow-[0px_0px_10px_0px_#D0C3FF] lg:p-12"
            onClick={() =>
              modalHandler(
                prasutModal,
                "Paraşüt entegrasyonu ile pazaryerleri ve e-ticaret sitenize gelen siparişleri tek panelde görüntüleyin.",
                "Trendyol, Hepsiburada, N11 gibi pazaryerlerinden gelen siparişlerinizi Paraşüt üzerinden kolayca görüntüleyebilirsiniz. </br> </br> Kişisel e-ticaret sitenize gelen siparişlerinizi Paraşüt üzerinden kolayca görüntüleyebilirsiniz."
              )
            }
          >
            <div className="flex max-h-[88px] min-h-[44px] min-w-[44px]  items-center rounded-lg bg-white p-2.5 lg:min-h-[88px] lg:min-w-[88px]">
              <Image
                src={parasut}
                width={72}
                height={72}
                className="size-full object-contain"
                alt="parasut"
              />
            </div>
          </Link>
        </div>

        <div
          className={`fixed left-1/2 top-1/2 z-50 h-full w-[calc(100%-25px)] -translate-x-1/2 -translate-y-1/2 lg:absolute ${
            isShow ? "block" : "hidden"
          }`}
        >
          <IntegrationsModal
            logo={modalContent.logo}
            title={modalContent.title}
            description={modalContent.description}
            visible={isShow}
            hide={setIsShow}
          />
        </div>
      </div>
    </section>
  );
}
