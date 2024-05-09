"use client";

import { useFormStatus } from "react-dom";
import { cn } from "#shadcn/lib/utils";
import { Button, ButtonProps } from "#shadcn/components/button";

import { Spinner } from "./spinner";

export const SubmitButton = ({ className, ...restProperties }: ButtonProps) => {
  const { pending } = useFormStatus();

  if (pending) {
    return (
      <div className={cn("relative h-10", className)}>
        <div className="h-10">
          <Spinner className="h-10" label="" />
        </div>
      </div>
    );
  }

  return (
    <Button
      disabled={pending}
      aria-disabled={pending}
      className={className}
      {...restProperties}
      type="submit"
    />
  );
};
