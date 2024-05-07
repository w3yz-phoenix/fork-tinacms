import { z } from "zod";
import { cn } from "@@shadcn/lib/utils";

import { withZod } from "./zod-component";

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

export const Button = withZod(
  "Button",
  ButtonPropertiesSchema,
  ({ as = "button", className, ...buttonProperties }) => {
    const Component = as;

    return (
      <Component
        {...buttonProperties}
        className={cn(
          "h-10 w-full rounded border border-none bg-[#EC8065] p-2.5 text-base font-semibold text-white outline-none transition-all",
          className
        )}
      />
    );
  }
);
