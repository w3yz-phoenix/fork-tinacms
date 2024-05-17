"use client";

import { IconChevronDown, IconChevronUp } from "@tabler/icons-react";
import { useTransition } from "react";

type Properties = {
  quantity: number;
  isPending?: boolean;
  incrementAction: (...args: any[]) => Promise<void>;
  decrementAction: (...args: any[]) => Promise<void>;
};

export const CheckoutLineQuantity = (props: Properties) => {
  const [isPending, startQuantityTransition] = useTransition();

  return (
    <div className="flex w-16 max-w-full items-center gap-2">
      <div className="flex size-10 items-center justify-center rounded border border-[#CFD1D2] font-medium text-[#252627]">
        {isPending ? "Updating" : props.quantity}
      </div>
      <div className="flex flex-col">
        <button
          type="button"
          className="relative size-5 aria-disabled:cursor-not-allowed aria-disabled:text-[#ADB0B3]"
          onClick={() => {
            if (isPending) return;
            startQuantityTransition(props.incrementAction);
          }}
          aria-disabled={props.quantity >= 50 || isPending}
          disabled={props.quantity >= 50 || isPending}
        >
          <IconChevronUp size={16} />
        </button>
        <button
          type="button"
          className="relative size-5 aria-disabled:cursor-not-allowed aria-disabled:text-[#ADB0B3]"
          onClick={() => {
            if (isPending) return;
            startQuantityTransition(props.decrementAction);
          }}
          aria-disabled={props.quantity <= 1 || isPending}
          disabled={props.quantity <= 1 || isPending}
        >
          <IconChevronDown size={16} />
        </button>
      </div>
    </div>
  );
};
