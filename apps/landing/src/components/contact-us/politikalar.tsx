"use client";
import { useState } from "react";

export function Politikalar() {
  const [policy, setPolicy] = useState("cerez");
  return (
    <div className="flex max-w-[1390px] flex-col bg-[#FFF] px-4 py-[105px]">
      <h3 className="text-xl font-semibold text-[#6941C6]">Yasal Metinler</h3>
      <h1 className="py-[16px] text-7xl font-semibold text-[#101828] ">
        Kullanım Politikaları
      </h1>
      <p className="max-w-[650px] text-2xl font-normal text-[#475467]">
        Ziyaretçilerimizin kullanıcı deneyimlerini geliştirebilmelerini sağlamak
        için sunduğumuz politikalar ile ilgili bilgi alın. Detaylı bilgi için
        bize ulaşmaktan çekinmeyin.
      </p>
      <div className="flex flex-col pt-[40px] lg:flex-row ">
        <div className="flex flex-row pt-4 max-lg:justify-center lg:flex-col lg:pr-8">
          <div className="flex flex-col-reverse pt-4  lg:flex-row">
            <div
              className={`sm: ${
                policy === "cerez"
                  ? "ml-2 rounded-[199px] bg-[#6018BB] max-lg:mt-1 max-lg:h-1 max-lg:w-[93%] lg:h-9 lg:w-[3px]"
                  : "hidden"
              }`}
            />
            <button
              onClick={() => setPolicy("cerez")}
              className={`${
                policy === "cerez"
                  ? "ml-2 rounded-lg   bg-[#F6F2FF] px-4  py-2 text-[14px] font-normal text-[#24262D]"
                  : "ml-2   bg-[#FFF]  px-4 py-2 text-[14px] font-normal text-[#565E73]"
              }`}
            >
              Çerez Politikası
            </button>
          </div>
          <div className="flex flex-col-reverse max-lg:ml-1 max-lg:pt-4 lg:mt-[13px] lg:flex-row">
            <div
              className={`${
                policy === "gizlilik"
                  ? "ml-2 rounded-[199px] bg-[#6018BB] max-lg:mt-1 max-lg:h-1 max-lg:w-[93%] lg:h-9 lg:w-[3px]"
                  : "hidden"
              }`}
            />
            <button
              onClick={() => setPolicy("gizlilik")}
              className={`${
                policy === "gizlilik"
                  ? "ml-2 rounded-lg   bg-[#F6F2FF] px-4  py-2 text-[14px] font-normal text-[#24262D]"
                  : "ml-2   bg-[#FFF]  px-4 py-2 text-[14px] font-normal text-[#565E73]"
              }`}
            >
              Gizlilik Politikası
            </button>
          </div>
          <div className="flex flex-col-reverse max-lg:ml-1 max-lg:pt-4 lg:mt-[13px] lg:flex-row">
            <div
              className={`${
                policy === "iade"
                  ? "ml-2 rounded-[199px] bg-[#6018BB] max-lg:mt-1 max-lg:h-1 max-lg:w-[93%] lg:h-9 lg:w-[3px]"
                  : "hidden"
              }`}
            />
            <button
              onClick={() => setPolicy("iade")}
              className={`${
                policy === "iade"
                  ? "ml-2 rounded-lg   bg-[#F6F2FF] px-4  py-2 text-[14px] font-normal text-[#24262D]"
                  : "ml-2   bg-[#FFF]  px-4 py-2 text-[14px] font-normal text-[#565E73]"
              }`}
            >
              İade Politikası
            </button>
          </div>
        </div>
        <div className="flex max-w-[800px] flex-col bg-[#FAFAFC] max-lg:pt-8 lg:p-6 xl:max-w-[1161px]">
          {policy === "cerez" ? (
            <div className="flex flex-col pt-3">
              <h1 className="text-2xl font-medium text-[#101828]">
                Çerez Politikası
              </h1>
              <p className="pt-3 text-xl font-normal text-[#475467]">
                Genel bilgi Bu çerez politikası, W3yz ve ilgili şirketinin
                www.w3yz.com da, web sitelerimizde, mobil uygulamamızda,
                çevrimiçi ürünümüzde ve w3yz in işlettiği ve bu politikaya
                bağlantı veren diğer web sitelerinde çerezleri ve ilgili
                teknolojileri nasıl kullandığını açıklar. Biz, Şirket Adı,
                olarak güvenliğinize önem veriyor ve bu Çerez Politikası ile siz
                sevgili ziyaretçilerimizi, web sitemizde hangi çerezleri, hangi
                amaçla kullandığımız ve çerez ayarlarınızı nasıl
                değiştireceğiniz konularında kısaca bilgilendirmeyi
                hedefliyoruz. Sizlere daha iyi hizmet verebilmek adına, çerezler
                vasıtasıyla, ne tür kişisel verilerinizin hangi amaçla
                toplandığı ve nasıl işlendiği konularında, kısaca bilgi sahibi
                olmak için lütfen bu Çerez Politikasını okuyunuz. Daha fazla
                bilgi için Gizlilik Politikamıza göz atabilir ya da bizlerle
                çekinmeden iletişime geçebilirsiniz. Çerez Nedir? Çerezler,
                kullanıcıların web sitelerini daha verimli bir şekilde
                kullanabilmeleri adına, cihazlarına kaydedilen küçük
                dosyacıklardır. Çerezler vasıtasıyla kullanıcıların bilgilerinin
                işleniyor olması sebebiyle, 6698 sayılı Kişisel Verilerin
                Korunması Kanunu gereğince, kullanıcıların bilgilendirilmeleri
                ve onaylarının alınması gerekmektedir. Bizler de siz sevgili
                ziyaretçilerimizin, web sitemizden en verimli şekilde
                yararlanabilmelerini ve siz sevgili ziyaretçilerimizin kullanıcı
                deneyimlerinin geliştirilebilmesini sağlamak adına, çeşitli
                çerezler kullanmaktayız. 1. Zorunlu Çerezler Zorunlu çerezler,
                web sitesine ilişkin temel işlevleri etkinleştirerek web
                sitesinin kullanılabilir hale gelmesini sağlayan çerezlerdir.
                Web sitesi bu çerezler olmadan düzgün çalışmaz. Siteyi
                kullandığınız sürece bu çerezler kabul edilmiş sayılacaktır. 2.
                Performans Çerezleri Performans çerezleri, ziyaretçilerin web
                sitesine ilişkin kullanım bilgilerini ve tercihlerini anonim
                olarak toplayan ve bu sayede web sitesinin performansının
                geliştirilmesine olanak sağlayan çerezlerdir. 3. Fonksiyonel
                Çerezler Fonksiyonel çerezler, kullanıcıların web sitesine
                ilişkin geçmiş kullanımlarından yola çıkılarak gelecekteki
                ziyaretlerinde tanınmalarını ve hatırlanmalarını sağlayan ve bu
                sayede web sitelerinin kullanıcılara dil, bölge vb. gibi
                kişiselleştirilmiş bir hizmet sunmasına olanak tanıyan
                çerezlerdir. 4. Reklam Çerezleri Reklam çerezleri, üçüncü
                taraflara ait çerezlerdir ve web sitelerinde ziyaretçilerin
                davranışlarını izlemek için kullanılırlar. Bu çerezlerin
                amaçları, ziyaretçilerin ihtiyaçlarına yönelik ilgilerini
                çekecek reklamların gösterilmesine yardımcı olmaktır ve
                sorumluluğu çerez sahibi üçüncü taraflara aittir. Çerezler İle
                İşlenen Kişisel Veriler Nelerdir? Kimlik (isim, soy isim, doğum
                tarihi vb.) ve iletişim (adres, e-posta adresi, telefon, IP,
                konum vb.) bilgileriniz tarafımızca, çerezler (cookies)
                vasıtasıyla, otomatik veya otomatik olmayan yöntemlerle ve bazen
                de analitik sağlayıcılar, reklam ağları, arama bilgi
                sağlayıcıları, teknoloji sağlayıcıları gibi üçüncü taraflardan
                elde edilerek, kaydedilerek, depolanarak ve güncellenerek,
                aramızdaki hizmet ve sözleşme ilişkisi çerçevesinde ve
                süresince, meşru menfaat işleme şartına dayanılarak
                işlenecektir. Çerezler Hangi Amaçla Kullanılmaktadır? Web
                sitemizde, şüpheli eylemlerin tespiti yoluyla güvenliğin
                sağlanması, kullanıcıların tercihleri doğrultusunda işlevsellik
                ve performansın artırılması, ürünlerin ve hizmetlerin
                geliştirilmesi ve kişiselleştirilmesi ile bu hizmetlere ulaşımın
                kolaylaştırılması, sözleşmesel ve hukuki sorumlulukların yerine
                getirilmesi amaçlı çerezler kullanmaktadır. Ayrıca
                kullanıcıların daha geniş kapsamlı hizmet sağlayıcılar ile
                buluşturulabilmesi amacıyla reklam çerezleri ve üçüncü
                taraflarla bilgi paylaşımı da söz konusudur. Çerezler Nasıl
                Yönetilmektedir? Tüm bu açıklamalardan sonra, hangi çerezlerin
                kullanılacağı konusu, tamamen kullanıcılarımızın özgür
                iradelerine bırakılmıştır. Çerez tercihlerinizi, tarayıcınızın
                ayarlarından silerek ya da engelleyerek, web sitemize adım
                attığınız anda yönetebilir ya da gelecekte, istediğiniz zaman bu
                ayarları değiştirebilirsiniz. Daha ayrıntılı bilgi için Gizlilik
                Politikamıza göz atabilir ya da bizlerle info@w3yz.com e-mail
                adresi üzerinden iletişime geçebilirsiniz.
              </p>
            </div>
          ) : (
            <div></div>
          )}
          {policy === "gizlilik" ? (
            <div className="flex flex-col pt-3">
              <h1 className="text-2xl font-medium text-[#101828]">
                Gizlilik Politikası
              </h1>
              <p className="pt-3 text-xl font-normal text-[#475467]">
                Genel bilgi Bu çerez politikası, W3yz ve ilgili şirketinin
                www.w3yz.com da, web sitelerimizde, mobil uygulamamızda,
                çevrimiçi ürünümüzde ve w3yz in işlettiği ve bu politikaya
                bağlantı veren diğer web sitelerinde çerezleri ve ilgili
                teknolojileri nasıl kullandığını açıklar. Biz, Şirket Adı,
                olarak güvenliğinize önem veriyor ve bu Çerez Politikası ile siz
                sevgili ziyaretçilerimizi, web sitemizde hangi çerezleri, hangi
                amaçla kullandığımız ve çerez ayarlarınızı nasıl
                değiştireceğiniz konularında kısaca bilgilendirmeyi
                hedefliyoruz. Sizlere daha iyi hizmet verebilmek adına, çerezler
                vasıtasıyla, ne tür kişisel verilerinizin hangi amaçla
                toplandığı ve nasıl işlendiği konularında, kısaca bilgi sahibi
                olmak için lütfen bu Çerez Politikasını okuyunuz. Daha fazla
                bilgi için Gizlilik Politikamıza göz atabilir ya da bizlerle
                çekinmeden iletişime geçebilirsiniz. Çerez Nedir? Çerezler,
                kullanıcıların web sitelerini daha verimli bir şekilde
                kullanabilmeleri adına, cihazlarına kaydedilen küçük
                dosyacıklardır. Çerezler vasıtasıyla kullanıcıların bilgilerinin
                işleniyor olması sebebiyle, 6698 sayılı Kişisel Verilerin
                Korunması Kanunu gereğince, kullanıcıların bilgilendirilmeleri
                ve onaylarının alınması gerekmektedir. Bizler de siz sevgili
                ziyaretçilerimizin, web sitemizden en verimli şekilde
                yararlanabilmelerini ve siz sevgili ziyaretçilerimizin kullanıcı
                deneyimlerinin geliştirilebilmesini sağlamak adına, çeşitli
                çerezler kullanmaktayız. 1. Zorunlu Çerezler Zorunlu çerezler,
                web sitesine ilişkin temel işlevleri etkinleştirerek web
                sitesinin kullanılabilir hale gelmesini sağlayan çerezlerdir.
                Web sitesi bu çerezler olmadan düzgün çalışmaz. Siteyi
                kullandığınız sürece bu çerezler kabul edilmiş sayılacaktır. 2.
                Performans Çerezleri Performans çerezleri, ziyaretçilerin web
                sitesine ilişkin kullanım bilgilerini ve tercihlerini anonim
                olarak toplayan ve bu sayede web sitesinin performansının
                geliştirilmesine olanak sağlayan çerezlerdir. 3. Fonksiyonel
                Çerezler Fonksiyonel çerezler, kullanıcıların web sitesine
                ilişkin geçmiş kullanımlarından yola çıkılarak gelecekteki
                ziyaretlerinde tanınmalarını ve hatırlanmalarını sağlayan ve bu
                sayede web sitelerinin kullanıcılara dil, bölge vb. gibi
                kişiselleştirilmiş bir hizmet sunmasına olanak tanıyan
                çerezlerdir. 4. Reklam Çerezleri Reklam çerezleri, üçüncü
                taraflara ait çerezlerdir ve web sitelerinde ziyaretçilerin
                davranışlarını izlemek için kullanılırlar. Bu çerezlerin
                amaçları, ziyaretçilerin ihtiyaçlarına yönelik ilgilerini
                çekecek reklamların gösterilmesine yardımcı olmaktır ve
                sorumluluğu çerez sahibi üçüncü taraflara aittir. Çerezler İle
                İşlenen Kişisel Veriler Nelerdir? Kimlik (isim, soy isim, doğum
                tarihi vb.) ve iletişim (adres, e-posta adresi, telefon, IP,
                konum vb.) bilgileriniz tarafımızca, çerezler (cookies)
                vasıtasıyla, otomatik veya otomatik olmayan yöntemlerle ve bazen
                de analitik sağlayıcılar, reklam ağları, arama bilgi
                sağlayıcıları, teknoloji sağlayıcıları gibi üçüncü taraflardan
                elde edilerek, kaydedilerek, depolanarak ve güncellenerek,
                aramızdaki hizmet ve sözleşme ilişkisi çerçevesinde ve
                süresince, meşru menfaat işleme şartına dayanılarak
                işlenecektir. Çerezler Hangi Amaçla Kullanılmaktadır? Web
                sitemizde, şüpheli eylemlerin tespiti yoluyla güvenliğin
                sağlanması, kullanıcıların tercihleri doğrultusunda işlevsellik
                ve performansın artırılması, ürünlerin ve hizmetlerin
                geliştirilmesi ve kişiselleştirilmesi ile bu hizmetlere ulaşımın
                kolaylaştırılması, sözleşmesel ve hukuki sorumlulukların yerine
                getirilmesi amaçlı çerezler kullanmaktadır. Ayrıca
                kullanıcıların daha geniş kapsamlı hizmet sağlayıcılar ile
                buluşturulabilmesi amacıyla reklam çerezleri ve üçüncü
                taraflarla bilgi paylaşımı da söz konusudur. Çerezler Nasıl
                Yönetilmektedir? Tüm bu açıklamalardan sonra, hangi çerezlerin
                kullanılacağı konusu, tamamen kullanıcılarımızın özgür
                iradelerine bırakılmıştır. Çerez tercihlerinizi, tarayıcınızın
                ayarlarından silerek ya da engelleyerek, web sitemize adım
                attığınız anda yönetebilir ya da gelecekte, istediğiniz zaman bu
                ayarları değiştirebilirsiniz. Daha ayrıntılı bilgi için Gizlilik
                Politikamıza göz atabilir ya da bizlerle info@w3yz.com e-mail
                adresi üzerinden iletişime geçebilirsiniz.
              </p>
            </div>
          ) : (
            <div></div>
          )}
          {policy === "iade" ? (
            <div className="flex flex-col pt-3">
              <h1 className="text-2xl font-medium text-[#101828]">
                İade Politikası
              </h1>
              <p className="pt-3 text-xl font-normal text-[#475467]">
                Genel bilgi Bu çerez politikası, W3yz ve ilgili şirketinin
                www.w3yz.com da, web sitelerimizde, mobil uygulamamızda,
                çevrimiçi ürünümüzde ve w3yz in işlettiği ve bu politikaya
                bağlantı veren diğer web sitelerinde çerezleri ve ilgili
                teknolojileri nasıl kullandığını açıklar. Biz, Şirket Adı,
                olarak güvenliğinize önem veriyor ve bu Çerez Politikası ile siz
                sevgili ziyaretçilerimizi, web sitemizde hangi çerezleri, hangi
                amaçla kullandığımız ve çerez ayarlarınızı nasıl
                değiştireceğiniz konularında kısaca bilgilendirmeyi
                hedefliyoruz. Sizlere daha iyi hizmet verebilmek adına, çerezler
                vasıtasıyla, ne tür kişisel verilerinizin hangi amaçla
                toplandığı ve nasıl işlendiği konularında, kısaca bilgi sahibi
                olmak için lütfen bu Çerez Politikasını okuyunuz. Daha fazla
                bilgi için Gizlilik Politikamıza göz atabilir ya da bizlerle
                çekinmeden iletişime geçebilirsiniz. Çerez Nedir? Çerezler,
                kullanıcıların web sitelerini daha verimli bir şekilde
                kullanabilmeleri adına, cihazlarına kaydedilen küçük
                dosyacıklardır. Çerezler vasıtasıyla kullanıcıların bilgilerinin
                işleniyor olması sebebiyle, 6698 sayılı Kişisel Verilerin
                Korunması Kanunu gereğince, kullanıcıların bilgilendirilmeleri
                ve onaylarının alınması gerekmektedir. Bizler de siz sevgili
                ziyaretçilerimizin, web sitemizden en verimli şekilde
                yararlanabilmelerini ve siz sevgili ziyaretçilerimizin kullanıcı
                deneyimlerinin geliştirilebilmesini sağlamak adına, çeşitli
                çerezler kullanmaktayız. 1. Zorunlu Çerezler Zorunlu çerezler,
                web sitesine ilişkin temel işlevleri etkinleştirerek web
                sitesinin kullanılabilir hale gelmesini sağlayan çerezlerdir.
                Web sitesi bu çerezler olmadan düzgün çalışmaz. Siteyi
                kullandığınız sürece bu çerezler kabul edilmiş sayılacaktır. 2.
                Performans Çerezleri Performans çerezleri, ziyaretçilerin web
                sitesine ilişkin kullanım bilgilerini ve tercihlerini anonim
                olarak toplayan ve bu sayede web sitesinin performansının
                geliştirilmesine olanak sağlayan çerezlerdir. 3. Fonksiyonel
                Çerezler Fonksiyonel çerezler, kullanıcıların web sitesine
                ilişkin geçmiş kullanımlarından yola çıkılarak gelecekteki
                ziyaretlerinde tanınmalarını ve hatırlanmalarını sağlayan ve bu
                sayede web sitelerinin kullanıcılara dil, bölge vb. gibi
                kişiselleştirilmiş bir hizmet sunmasına olanak tanıyan
                çerezlerdir. 4. Reklam Çerezleri Reklam çerezleri, üçüncü
                taraflara ait çerezlerdir ve web sitelerinde ziyaretçilerin
                davranışlarını izlemek için kullanılırlar. Bu çerezlerin
                amaçları, ziyaretçilerin ihtiyaçlarına yönelik ilgilerini
                çekecek reklamların gösterilmesine yardımcı olmaktır ve
                sorumluluğu çerez sahibi üçüncü taraflara aittir. Çerezler İle
                İşlenen Kişisel Veriler Nelerdir? Kimlik (isim, soy isim, doğum
                tarihi vb.) ve iletişim (adres, e-posta adresi, telefon, IP,
                konum vb.) bilgileriniz tarafımızca, çerezler (cookies)
                vasıtasıyla, otomatik veya otomatik olmayan yöntemlerle ve bazen
                de analitik sağlayıcılar, reklam ağları, arama bilgi
                sağlayıcıları, teknoloji sağlayıcıları gibi üçüncü taraflardan
                elde edilerek, kaydedilerek, depolanarak ve güncellenerek,
                aramızdaki hizmet ve sözleşme ilişkisi çerçevesinde ve
                süresince, meşru menfaat işleme şartına dayanılarak
                işlenecektir. Çerezler Hangi Amaçla Kullanılmaktadır? Web
                sitemizde, şüpheli eylemlerin tespiti yoluyla güvenliğin
                sağlanması, kullanıcıların tercihleri doğrultusunda işlevsellik
                ve performansın artırılması, ürünlerin ve hizmetlerin
                geliştirilmesi ve kişiselleştirilmesi ile bu hizmetlere ulaşımın
                kolaylaştırılması, sözleşmesel ve hukuki sorumlulukların yerine
                getirilmesi amaçlı çerezler kullanmaktadır. Ayrıca
                kullanıcıların daha geniş kapsamlı hizmet sağlayıcılar ile
                buluşturulabilmesi amacıyla reklam çerezleri ve üçüncü
                taraflarla bilgi paylaşımı da söz konusudur. Çerezler Nasıl
                Yönetilmektedir? Tüm bu açıklamalardan sonra, hangi çerezlerin
                kullanılacağı konusu, tamamen kullanıcılarımızın özgür
                iradelerine bırakılmıştır. Çerez tercihlerinizi, tarayıcınızın
                ayarlarından silerek ya da engelleyerek, web sitemize adım
                attığınız anda yönetebilir ya da gelecekte, istediğiniz zaman bu
                ayarları değiştirebilirsiniz. Daha ayrıntılı bilgi için Gizlilik
                Politikamıza göz atabilir ya da bizlerle info@w3yz.com e-mail
                adresi üzerinden iletişime geçebilirsiniz.
              </p>
            </div>
          ) : (
            <div></div>
          )}
        </div>
      </div>
    </div>
  );
}
