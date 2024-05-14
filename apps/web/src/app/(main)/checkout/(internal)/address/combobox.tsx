"use client";

import {
  type FieldValues,
  type Path,
  type UseFormReturn,
} from "react-hook-form";
import { CaretSortIcon, CheckIcon } from "@radix-ui/react-icons";

import { Button } from "#shadcn/components/button";
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
} from "#shadcn/components/command";
import {
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "#shadcn/components/form";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "#shadcn/components/popover";
import { cn } from "#shadcn/lib/utils";

export function InputCombobox<
  const T extends FieldValues,
  const TName extends Path<T>,
>({
  name,
  form,
  ...props
}: {
  name: TName;
  form: UseFormReturn<T, any, undefined>;
  label: string;
  placeholder: string;
  description: string;
  notFoundMessage: string;
  items: { label: string; value: T[TName] }[];
}) {
  return (
    <FormField
      control={form.control}
      name={name}
      render={({ field }) => (
        <FormItem className="flex flex-col">
          <FormLabel>{props.label}</FormLabel>
          <Popover>
            <PopoverTrigger asChild>
              <FormControl className="flex w-full">
                <Button
                  variant="outline"
                  role="combobox"
                  className={cn(
                    "w-full justify-between",
                    !field.value && "text-muted-foreground"
                  )}
                >
                  {field.value
                    ? props.items.find((item) => item.value === field.value)
                        ?.label
                    : props.placeholder}
                  <CaretSortIcon className="ml-2 size-4 shrink-0 opacity-50" />
                </Button>
              </FormControl>
            </PopoverTrigger>
            <PopoverContent className="w-full min-w-[200px] p-0">
              <Command>
                <CommandInput placeholder={props.placeholder} className="h-9" />
                <CommandEmpty>{props.notFoundMessage}</CommandEmpty>
                <CommandGroup>
                  {props.items.map((item) => (
                    <CommandItem
                      value={item.label}
                      key={item.value}
                      onSelect={() => {
                        form.setValue(name, item.value);
                      }}
                    >
                      {item.label}
                      <CheckIcon
                        className={cn(
                          "ml-auto h-4 w-4",
                          item.value === field.value
                            ? "opacity-100"
                            : "opacity-0"
                        )}
                      />
                    </CommandItem>
                  ))}
                </CommandGroup>
              </Command>
            </PopoverContent>
          </Popover>
          <FormDescription>{props.description}</FormDescription>
          <FormMessage />
        </FormItem>
      )}
    />
  );
}
