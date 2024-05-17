"use client";

import { OrderItemCard } from "./order-card";

export function ProfileOrders() {
  return (
    <div className="min-h-[calc(100vh-495px)] lg:max-w-[872px] 2xl:mx-auto">
      <div className="mb-20 flex flex-col md:gap-0">
        <div>
          <div className="hidden md:block">
            <h2 className="mb-3 text-3xl font-semibold leading-[38px] text-[#101828]">
              Siparişler
            </h2>
            <p className="mb-4 text-base font-normal leading-normal text-[#656565] md:mb-8">
              Tüm sipariş geçmişinizi görün ve takip edin.
            </p>
          </div>
        </div>

        <OrderItemCard />
      </div>
    </div>
  );
}
