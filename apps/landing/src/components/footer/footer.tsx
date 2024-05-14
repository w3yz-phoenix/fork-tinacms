import Image from "next/image";
import Link from "next/link";

export function Footer() {
  return (
    <div className="flex w-full justify-center  bg-white px-6 ">
      <div className="flex w-[1400px] flex-col ">
        <div className="flex py-[52px] max-lg:flex-col max-lg:items-center lg:justify-between">
          <div className="flex flex-col">
            <Image
              src="/assets/footerlogo.svg"
              width={86}
              height={32}
              alt="w3yz"
            />
            <div className="flex flex-row gap-x-2 pt-6">
              <Link href="https://www.tiktok.com/@w3yzcom/">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="12"
                  height="12"
                  viewBox="0 0 12 12"
                  fill="none"
                >
                  <path
                    d="M8.53626 0H6.51391V8.1739C6.51391 9.14783 5.7361 9.94783 4.76813 9.94783C3.80017 9.94783 3.02234 9.14783 3.02234 8.1739C3.02234 7.2174 3.78289 6.43477 4.71629 6.4V4.34783C2.65936 4.3826 1 6.06957 1 8.1739C1 10.2957 2.69393 12 4.78542 12C6.87689 12 8.57082 10.2783 8.57082 8.1739V3.9826C9.33137 4.53913 10.2647 4.86957 11.25 4.88697V2.83478C9.72893 2.78261 8.53626 1.53043 8.53626 0Z"
                    fill="#667085"
                  />
                </svg>
              </Link>
              <Link href="https://www.instagram.com/w3yz/">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="16"
                  height="16"
                  viewBox="0 0 16 16"
                  fill="none"
                >
                  <path
                    fillRule="evenodd"
                    clipRule="evenodd"
                    d="M8 2C6.3704 2 6.1664 2.0068 5.5264 2.036C4.8876 2.0652 4.4512 2.1668 4.0696 2.3152C3.6696 2.4656 3.3068 2.7016 3.0068 3.0072C2.70169 3.30685 2.46554 3.6694 2.3148 4.0696C2.1672 4.4512 2.0652 4.888 2.036 5.5268C2.0072 6.1664 2 6.37 2 8C2 9.63 2.0068 9.8336 2.036 10.4736C2.0652 11.1124 2.1668 11.5488 2.3152 11.9304C2.4656 12.3304 2.7016 12.6932 3.0072 12.9932C3.30686 13.2983 3.6694 13.5344 4.0696 13.6852C4.4512 13.8332 4.8876 13.9348 5.5264 13.964C6.1664 13.9932 6.3704 14 8 14C9.6296 14 9.8336 13.9932 10.4736 13.964C11.1124 13.9348 11.5488 13.8332 11.9304 13.6848C12.3304 13.5344 12.6932 13.2984 12.9932 12.9928C13.2983 12.6931 13.5345 12.3306 13.6852 11.9304C13.8332 11.5488 13.9348 11.1124 13.964 10.4736C13.9932 9.8336 14 9.6296 14 8C14 6.3704 13.9932 6.1664 13.964 5.5264C13.9348 4.8876 13.8332 4.4512 13.6848 4.0696C13.5342 3.66923 13.298 3.30653 12.9928 3.0068C12.6931 2.70169 12.3306 2.46554 11.9304 2.3148C11.5488 2.1672 11.112 2.0652 10.4732 2.036C9.8336 2.0072 9.63 2 8 2ZM8 3.0812C9.602 3.0812 9.792 3.0872 10.4248 3.116C11.0096 3.1428 11.3272 3.24 11.5388 3.3228C11.8188 3.4312 12.0188 3.5616 12.2288 3.7712C12.4388 3.9812 12.5688 4.1812 12.6772 4.4612C12.7596 4.6728 12.8572 4.9904 12.884 5.5752C12.9128 6.208 12.9188 6.398 12.9188 8C12.9188 9.602 12.9128 9.792 12.884 10.4248C12.8572 11.0096 12.76 11.3272 12.6772 11.5388C12.5812 11.7994 12.428 12.0352 12.2288 12.2288C12.0352 12.428 11.7994 12.5812 11.5388 12.6772C11.3272 12.7596 11.0096 12.8572 10.4248 12.884C9.792 12.9128 9.6024 12.9188 8 12.9188C6.3976 12.9188 6.208 12.9128 5.5752 12.884C4.9904 12.8572 4.6728 12.76 4.4612 12.6772C4.20058 12.5812 3.9648 12.428 3.7712 12.2288C3.57207 12.0352 3.41885 11.7994 3.3228 11.5388C3.2404 11.3272 3.1428 11.0096 3.116 10.4248C3.0872 9.792 3.0812 9.602 3.0812 8C3.0812 6.398 3.0872 6.208 3.116 5.5752C3.1428 4.9904 3.24 4.6728 3.3228 4.4612C3.4312 4.1812 3.5616 3.9812 3.7712 3.7712C3.96478 3.57202 4.20056 3.41879 4.4612 3.3228C4.6728 3.2404 4.9904 3.1428 5.5752 3.116C6.208 3.0872 6.398 3.0812 8 3.0812Z"
                    fill="#667085"
                  />
                  <path
                    fillRule="evenodd"
                    clipRule="evenodd"
                    d="M8.00001 10.0019C7.73711 10.0019 7.47678 9.95008 7.23388 9.84947C6.99099 9.74886 6.77029 9.60139 6.58439 9.41549C6.39848 9.22958 6.25102 9.00889 6.15041 8.76599C6.0498 8.5231 5.99802 8.26277 5.99802 7.99986C5.99802 7.73695 6.0498 7.47662 6.15041 7.23373C6.25102 6.99083 6.39848 6.77013 6.58439 6.58423C6.77029 6.39833 6.99099 6.25086 7.23388 6.15025C7.47678 6.04964 7.73711 5.99786 8.00001 5.99786C8.53098 5.99786 9.04019 6.20878 9.41564 6.58423C9.79109 6.95968 10.002 7.4689 10.002 7.99986C10.002 8.53082 9.79109 9.04004 9.41564 9.41549C9.04019 9.79094 8.53098 10.0019 8.00001 10.0019ZM8.00001 4.91586C7.18209 4.91586 6.39766 5.24078 5.8193 5.81914C5.24094 6.3975 4.91602 7.18193 4.91602 7.99986C4.91602 8.81779 5.24094 9.60221 5.8193 10.1806C6.39766 10.7589 7.18209 11.0839 8.00001 11.0839C8.81794 11.0839 9.60237 10.7589 10.1807 10.1806C10.7591 9.60221 11.084 8.81779 11.084 7.99986C11.084 7.18193 10.7591 6.3975 10.1807 5.81914C9.60237 5.24078 8.81794 4.91586 8.00001 4.91586ZM11.9812 4.85986C11.9812 5.0532 11.9044 5.23863 11.7677 5.37534C11.631 5.51205 11.4456 5.58886 11.2522 5.58886C11.0589 5.58886 10.8734 5.51205 10.7367 5.37534C10.6 5.23863 10.5232 5.0532 10.5232 4.85986C10.5232 4.66652 10.6 4.48109 10.7367 4.34438C10.8734 4.20766 11.0589 4.13086 11.2522 4.13086C11.4456 4.13086 11.631 4.20766 11.7677 4.34438C11.9044 4.48109 11.9812 4.66652 11.9812 4.85986Z"
                    fill="#667085"
                  />
                </svg>
              </Link>
              <Link href="https://x.com/w3yzcom">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="13"
                  height="14"
                  viewBox="0 0 13 14"
                  fill="none"
                >
                  <path
                    d="M10.2383 0.5H12.2317L7.87665 6.00667L13 13.5H8.98846L5.84648 8.95533L2.25133 13.5H0.25671L4.91485 7.61L0 0.5H4.11338L6.95346 4.654L10.2383 0.5ZM9.53864 12.18H10.6432L3.51319 1.75067H2.32786L9.53864 12.18Z"
                    fill="#667085"
                  />
                </svg>
              </Link>
              <Link href="https://tr.pinterest.com/w3yzcom/">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="16"
                  height="16"
                  viewBox="0 0 16 16"
                  fill="none"
                >
                  <path
                    d="M7.99742 1.33301C4.3117 1.33301 1.3335 4.31669 1.3335 7.99693C1.3335 10.8216 3.0886 13.2348 5.5677 14.2056C5.50736 13.6791 5.458 12.8674 5.58963 12.2915C5.7103 11.7704 6.36846 8.9787 6.36846 8.9787C6.36846 8.9787 6.17102 8.57832 6.17102 7.99145C6.17102 7.06453 6.70851 6.37346 7.37764 6.37346C7.94806 6.37346 8.2223 6.80126 8.2223 7.31134C8.2223 7.88175 7.8603 8.73737 7.66834 9.53265C7.50928 10.1963 8.00291 10.7393 8.65559 10.7393C9.84028 10.7393 10.7508 9.48877 10.7508 7.68979C10.7508 6.09374 9.60444 4.98034 7.96451 4.98034C6.0668 4.98034 4.9534 6.40087 4.9534 7.87078C4.9534 8.44119 5.17279 9.05547 5.44703 9.39005C5.50188 9.45586 5.50736 9.5162 5.49091 9.58201C5.44155 9.79043 5.32636 10.2457 5.30443 10.3389C5.277 10.4596 5.2057 10.487 5.07955 10.4267C4.25684 10.0318 3.74128 8.81415 3.74128 7.83787C3.74128 5.73723 5.26603 3.80661 8.14551 3.80661C10.4546 3.80661 12.2536 5.45202 12.2536 7.65688C12.2536 9.95497 10.8056 11.8033 8.79819 11.8033C8.12356 11.8033 7.48734 11.4523 7.27344 11.0355C7.27344 11.0355 6.93887 12.3079 6.8566 12.6205C6.70851 13.2019 6.30264 13.9259 6.0284 14.3702C6.65367 14.5621 7.31183 14.6663 8.00291 14.6663C11.6832 14.6663 14.6668 11.6827 14.6668 8.00242C14.6614 4.31669 11.6777 1.33301 7.99742 1.33301Z"
                    fill="#667085"
                  />
                </svg>
              </Link>
              <Link href="https://www.linkedin.com/company/w3yz/">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="16"
                  height="16"
                  viewBox="0 0 16 16"
                  fill="none"
                >
                  <path
                    d="M14 2.88235V13.1176C14 13.3517 13.907 13.5761 13.7416 13.7416C13.5761 13.907 13.3517 14 13.1176 14H2.88235C2.64834 14 2.42391 13.907 2.25844 13.7416C2.09296 13.5761 2 13.3517 2 13.1176V2.88235C2 2.64834 2.09296 2.42391 2.25844 2.25844C2.42391 2.09296 2.64834 2 2.88235 2H13.1176C13.3517 2 13.5761 2.09296 13.7416 2.25844C13.907 2.42391 14 2.64834 14 2.88235ZM5.52941 6.58824H3.76471V12.2353H5.52941V6.58824ZM5.68824 4.64706C5.68917 4.51357 5.66379 4.38121 5.61357 4.25753C5.56334 4.13385 5.48925 4.02128 5.39552 3.92623C5.30178 3.83119 5.19025 3.75554 5.06728 3.7036C4.94431 3.65166 4.81231 3.62445 4.67882 3.62353H4.64706C4.3756 3.62353 4.11526 3.73137 3.92331 3.92331C3.73137 4.11526 3.62353 4.3756 3.62353 4.64706C3.62353 4.91852 3.73137 5.17885 3.92331 5.3708C4.11526 5.56275 4.3756 5.67059 4.64706 5.67059C4.78055 5.67387 4.91339 5.65082 5.03797 5.60275C5.16255 5.55468 5.27644 5.48253 5.37313 5.39043C5.46982 5.29833 5.54742 5.18808 5.60149 5.06598C5.65555 4.94388 5.68503 4.81232 5.68824 4.67882V4.64706ZM12.2353 8.80471C12.2353 7.10706 11.1553 6.44706 10.0824 6.44706C9.73105 6.42947 9.38128 6.50429 9.06791 6.66407C8.75456 6.82385 8.48856 7.06299 8.29647 7.35765H8.24706V6.58824H6.58824V12.2353H8.35294V9.23176C8.32743 8.92415 8.42433 8.6189 8.62258 8.38232C8.82084 8.14573 9.10443 7.99693 9.41177 7.96824H9.47882C10.04 7.96824 10.4565 8.32118 10.4565 9.21059V12.2353H12.2212L12.2353 8.80471Z"
                    fill="#667085"
                  />
                </svg>
              </Link>
            </div>
          </div>
          <div className="grid grid-cols-2 pl-0 text-[18px] font-normal text-[#667085] max-lg:w-full  max-lg:gap-y-12 max-lg:pt-10 max-sm:text-[12px] md:grid-cols-4  lg:pl-7 2xl:pl-0">
            <span className="flex flex-col">
              <p className=" font-semibold">Kanallar</p>
              <Link className="pt-3" href="/">
                Çözümler
              </Link>
              <Link className="pt-3" href="/">
                Community
              </Link>
            </span>
            <span className=" flex flex-col ">
              <p className=" font-semibold">Politikalar</p>
              <Link className="pt-3" href="/iletisim">
                Çerez Politikası
              </Link>
              <Link className="pt-3" href="/iletisim">
                Gizlilik Politikası
              </Link>
              <Link className="pt-3" href="/iletisim">
                İade Politikası
              </Link>
            </span>
            <span className=" flex flex-col">
              <p className=" font-semibold">İletişim</p>
              <Link className="pt-3" href="mailto:info@w3yz.com">
                info@w3yz.com
              </Link>
            </span>
            <span className="flex flex-col">
              <p className="pb-3  font-semibold">Adres</p>
              Çifte Havuzlar Mah. <br /> Eski Londra Asfaltı Cad.
              <br /> Kuluçka Mrk. <br /> A1 Blok No: 151 /1C İç Kapı No: B34
              <br /> ESENLER/ İSTANBUL
            </span>
          </div>
        </div>
        <div className="flex py-[52px]  max-lg:flex-col max-lg:items-center lg:justify-between">
          <div className="text-[14px] font-medium text-[#464C5E]">
            @ 2024 W3yz Tüm hakları saklıdır
          </div>
          <div>
            <Image
              src="/assets/odemesistemi.png"
              width={397}
              height={34}
              alt="ödeme sistemi"
              className="max-lg:pt-4"
            />
          </div>
        </div>
      </div>
    </div>
  );
}
