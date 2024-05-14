"use client";

import Image from "next/image";
import { forwardRef, useState } from "react";

import { cn } from "#landing/app/lib/utils";
import eyeIcon from "#landing/../public/assets/visibility.svg";
import closedEyeIcon from "#landing/../public/assets/visibility_off.svg";

type FormInputProperties = {
  label: string;
  error?: string;
} & React.HTMLProps<HTMLInputElement>;

export const FormInput = forwardRef<HTMLInputElement, FormInputProperties>(
  ({ label, error, ...props }, ref) => {
    const id = `input-${props.name}`;
    const [isVisible, setIsVisible] = useState(false);
    return (
      <div className="flex flex-col gap-1">
        <label
          className="text-xs font-medium leading-none text-[#292929]"
          htmlFor={id}
        >
          {label}
        </label>
        <div className="relative w-full">
          <input
            {...props}
            ref={ref}
            className={cn(
              "h-[50px] w-full rounded-lg border border-[#BDBDBD] px-4 py-[13px] text-base font-normal text-[#4C4F52] placeholder:[#CFD1D2] focus:border-emerald-500 focus:outline-none",
              error && "border-[#B70000]"
            )}
            type={isVisible ? "text" : props.type || "text"}
            id={id}
            placeholder={props.placeholder}
          />
          {props.type === "password" && (
            <button
              type="button"
              onClick={() => setIsVisible(!isVisible)}
              className="absolute right-2.5 top-1/2 -translate-y-1/2"
            >
              <Image
                width={24}
                height={24}
                src={isVisible ? eyeIcon : closedEyeIcon}
                alt="Eye icon"
              />
            </button>
          )}
        </div>
        <div className="text-sm italic leading-4 text-red-800">{error}</div>
      </div>
    );
  }
);

// FIXME: Find a better way to do this
FormInput.displayName = "FormInput";

type FormTextAreaProperties = {
  label: string;
  error?: string;
} & React.HTMLProps<HTMLTextAreaElement>;

export const FormTextArea = forwardRef<
  HTMLTextAreaElement,
  FormTextAreaProperties
>(({ label, error, ...props }, reference) => {
  return (
    <div className="flex flex-col gap-1">
      <label
        className=" text-sm font-normal text-[color:#4C4F52] focus:text-[color:#ADB0B3]"
        htmlFor={props.name}
      >
        {label}
      </label>
      <div className="relative w-full">
        <textarea
          ref={reference}
          {...props}
          className={cn(
            "h-[118px] w-full rounded border border-[color:#CFD1D2] p-2.5 text-sm font-normal text-[color:#4C4F52] placeholder:[color:#CFD1D2] focus:border-[color:#ADB0B3] focus:outline-none resize-none",
            error && "border-red-800"
          )}
          id={props.id}
          placeholder={props.placeholder}
        />
      </div>
      <div className="text-sm italic leading-4 text-red-800">{error}</div>
    </div>
  );
});

FormTextArea.displayName = "FormTextArea";

export const FormInputDark = forwardRef<HTMLInputElement, FormInputProperties>(
  ({ label, error, ...props }, reference) => {
    return (
      <div className="flex flex-col gap-1">
        <label
          className=" text-sm font-normal text-[color:#4C4F52] focus:text-[color:#ADB0B3]"
          htmlFor={props.name}
        >
          {label}
        </label>
        <input
          {...props}
          ref={reference}
          className={cn(
            "h-11 rounded border border-[#CFD1D2] p-2.5 text-sm font-normal text-[#4C4F52] placeholder:text-[#4C4F52] focus:border-[color:#ADB0B3] focus:outline-none",
            error && "border-red-800"
          )}
          type={props.type || "text"}
          id={props.id}
          placeholder={props.placeholder}
        />
        <div className="text-sm italic leading-4 text-red-800">{error}</div>
      </div>
    );
  }
);

FormInputDark.displayName = "FormInputDark";
