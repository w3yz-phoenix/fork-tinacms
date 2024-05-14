"use client";

import { useFormStatus } from "react-dom";
import { z } from "zod";

import { cn } from "#landing/app/lib/utils";

import { Spinner } from "./spinner";

const ReactButtonComponentSchema =
  z.custom<
    React.ComponentType<React.ButtonHTMLAttributes<HTMLButtonElement>>
  >();

const ReactButtonPropertiesSchema =
  z.custom<React.ButtonHTMLAttributes<HTMLButtonElement>>();

export const ButtonPropertiesSchema = z.intersection(
  z.object({
    as: ReactButtonComponentSchema.or(z.literal("button"))
      .default("button")
      .optional(),
  }),
  ReactButtonPropertiesSchema
);

export type ButtonProperties = z.infer<typeof ButtonPropertiesSchema>;

export const SubmitButton = ({
  className,
  ...restProperties
}: ButtonProperties) => {
  const { pending } = useFormStatus();
  return pending ? (
    <div className={cn("relative h-10 w-full", className)}>
      <div className="h-10 w-full">
        <Spinner className="h-10 w-full" label="" />
      </div>
    </div>
  ) : (
    <button
      disabled={pending}
      aria-disabled={pending}
      className={cn(
        "rounded w-full bg-[#343a63] px-4 py-[7px] text-white hover:bg-[#5c66aa] disabled:bg-[#151e5646]",
        className
      )}
      type="submit"
      {...restProperties}
    />
  );
};
