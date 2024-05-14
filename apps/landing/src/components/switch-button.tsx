"use client";

import { cn } from "#landing/app/lib/utils";

interface ToggleProperties {
  disabled?: boolean;
  name?: string;
  value?: string;
  onChange?: (checked: boolean) => void;
  checked?: boolean;
}

export const Toggle = ({
  disabled,
  name,
  value,
  checked,
  onChange,
}: ToggleProperties) => {
  // const [checked, setChecked] = useState(false);
  return (
    <div>
      <>
        <label className="cursor-pointer">
          <div className="relative">
            <input
              type="checkbox"
              checked={checked}
              onChange={(event) => onChange?.(event.target.checked)}
              className="hidden"
              disabled={disabled}
              name={name}
              value={value}
            />
            <div
              className={cn(
                "flex h-7 w-[52px] items-center justify-start rounded-[100px] border border-gray-200 bg-white p-1 aria-disabled:border-gray-100",
                checked && "bg-blue-500 border-blue-200"
              )}
              aria-disabled={disabled}
            >
              <div
                className={cn(
                  "h-6 w-6 rounded-full border-2 border-gray-300 bg-gray-300 transition-transform duration-300 ease-in-out aria-disabled:bg-gray-100 aria-disabled:border-gray-100",
                  checked &&
                    "transform translate-x-[18px] bg-blue-500 border-white"
                )}
                aria-disabled={disabled}
              ></div>
            </div>
          </div>
        </label>
      </>
    </div>
  );
};
