"use client";

import { useFormStatus } from "react-dom";
import { cn } from "@@shadcn/lib/utils";

import { Button, ButtonProperties } from "./button";
import { Spinner } from "./spinner";

export const SubmitButton = ({
  className,
  ...restProperties
}: ButtonProperties) => {
  const { pending } = useFormStatus();
  return pending ? (
    <div className={cn("relative h-10", className)}>
      <div className="h-10">
        <Spinner className="h-10" label="" />
      </div>
    </div>
  ) : (
    <Button
      disabled={pending}
      aria-disabled={pending}
      className={cn(
        "rounded bg-[#EC8065] px-4 py-[7px] text-white hover:bg-[#CF7059] disabled:bg-[#FFD9D0]",
        className
      )}
      {...restProperties}
      type="submit"
    />
  );
};
