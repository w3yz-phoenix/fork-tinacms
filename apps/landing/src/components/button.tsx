"use client";

import Image from "next/image";
import { forwardRef } from "react";

type ButtonProperties = {
  picture?: string;
} & React.HTMLProps<HTMLButtonElement>;

export const ButtonGreen = forwardRef<HTMLButtonElement, ButtonProperties>(
  ({ ...props }, ref) => {
    return (
      <button
        ref={ref}
        className="flex h-12 w-80 items-center justify-center gap-2 rounded-lg bg-green-500 px-3 py-1.5 text-2xl font-medium leading-normal text-white hover:bg-green-700 disabled:bg-green-200 "
      >
        <span>
          {props.picture && (
            <Image width={11} height={11} src={props.picture} alt="icon" />
          )}
        </span>
        <span>{props.name}</span>
      </button>
    );
  }
);

ButtonGreen.displayName = "ButtonGreen";
