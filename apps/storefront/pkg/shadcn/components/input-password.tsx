import * as React from "react";

import { cn } from "#shadcn/lib/utils";

export interface InputProps
  extends React.InputHTMLAttributes<HTMLInputElement> {}

const InputPassword = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className, ...props }, ref) => {
    const [isVisible, setIsVisible] = React.useState(false);
    console.log(props.type);
    return (
      <div className="relative w-full">
        <input
          type={isVisible ? "text" : "password"}
          className={cn(
            "flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
            className
          )}
          ref={ref}
          {...props}
        />
        {props.type === "password" && (
          <button
            type="button"
            onClick={() => setIsVisible(!isVisible)}
            className="absolute right-2.5 top-1/2 -translate-y-1/2"
          >
            <div className="rounded-md border bg-slate-600 p-1 text-xs text-white">
              {isVisible ? "Göster" : "Gizle"}
            </div>
            {/* <Image
              width={20}
              height={20}
              src={isVisible ? EyeOpenIcon : EyeClosedIcon}
              alt="Eye icon"
            /> */}
          </button>
        )}
      </div>
    );
  }
);
InputPassword.displayName = "InputPassword";

export { InputPassword };
