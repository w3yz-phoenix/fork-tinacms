import Link from "next/link";

import { AddressItem } from "./address-item";
import { useCurrentUserAddressListQuery } from "@w3yz/ecom/api";
import { invariant } from "@w3yz/tools/lib";
import { ProfileAddressFormType } from "./schemas";

export default async function ProfileAddressPage() {
  async function fetchAddress() {
    const response = useCurrentUserAddressListQuery.fetcher({});

    invariant(response.userWithAddresses, "User not found");

    const addresses = response.userWithAddresses.addresses.map(
      (address: Partial<ProfileAddressFormType>) => address
    );

    return addresses;
  }
  const addresses = await fetchAddress();
  return (
    <div className="min-h-[calc(100vh-495px)] xl:w-[881px]">
      <div className="mb-20 flex flex-col items-center justify-between gap-6 md:flex-row">
        <div className="flex flex-col-reverse gap-[52px] md:flex-col md:gap-0">
          <div>
            <h2 className="mb-3 text-3xl font-semibold leading-[38px] text-[#101828]">
              Adreslerim
            </h2>
            <p className="text-base font-normal leading-normal text-[#656565]">
              Yeni adres oluşturun veya düzenleyin.
            </p>
          </div>
        </div>
        <Link
          href="/profile/address/create"
          type="submit"
          className="flex h-11 max-w-fit items-center justify-center gap-3 rounded bg-[#292929] px-7 text-white hover:bg-[#525252] md:max-w-fit"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="25"
            height="24"
            viewBox="0 0 25 24"
            fill="none"
          >
            <g clip-path="url(#clip0_3883_6350)">
              <path
                d="M12.5 5V19"
                stroke="white"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
              <path
                d="M5.5 12H19.5"
                stroke="white"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </g>
            <defs>
              <clipPath id="clip0_3883_6350">
                <rect
                  width="24"
                  height="24"
                  fill="white"
                  transform="translate(0.5)"
                />
              </clipPath>
            </defs>
          </svg>
          Adres Ekle
        </Link>
      </div>
      <div className="grid grid-cols-1 gap-10 md:grid-cols-2">
        <AddressItem />
        <AddressItem />
        <AddressItem />
        <AddressItem />
      </div>
    </div>
  );
}
