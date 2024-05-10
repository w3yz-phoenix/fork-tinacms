"use client";

import { Button } from "#shadcn/components/button";
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "#shadcn/components/form";
import { Input } from "#shadcn/components/input";
import { toast } from "#shadcn/components/use-toast";
import { zodResolver } from "@hookform/resolvers/zod";
import { useRouter } from "next/navigation";
import { useForm } from "react-hook-form";
import { z } from "zod";

import { InputCombobox } from "./combobox";
import {
  CheckoutAddressFormMetadata,
  CheckoutAddressFormSchema,
  type CheckoutAddressFormType,
} from "./schemas";

export function CheckoutAddressForm(props: {
  values?: Partial<CheckoutAddressFormType>;
  completeAction: (
    data: CheckoutAddressFormType
  ) => Promise<{ success?: boolean; error?: string } | undefined>;
  cancelAction: () => unknown;
}) {
  const router = useRouter();
  const form = useForm<z.infer<typeof CheckoutAddressFormSchema>>({
    resolver: zodResolver(CheckoutAddressFormSchema),
    defaultValues: {
      ...props.values,
    },
  });

  return (
    <Form {...form}>
      <form
        onSubmit={form.handleSubmit(async (data) => {
          const response = await props.completeAction(data);

          if (!response?.success) {
            console.error(response);

            toast({
              title: "Hata",
              description: response?.error,
              variant: "destructive",
            });
            return;
          }

          router.push("/checkout/awaiting-payment");
        })}
        className="flex flex-col gap-5"
      >
        <div className="flex gap-5">
          <FormField
            control={form.control}
            name="firstName"
            render={({ field }) => (
              <FormItem className="w-1/2">
                <FormLabel>
                  {CheckoutAddressFormMetadata.firstName.label}
                </FormLabel>
                <FormControl>
                  <Input
                    placeholder={
                      CheckoutAddressFormMetadata.firstName.placeholder
                    }
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  {CheckoutAddressFormMetadata.firstName.description}
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="lastName"
            render={({ field }) => (
              <FormItem className="w-1/2">
                <FormLabel>
                  {CheckoutAddressFormMetadata.lastName.label}
                </FormLabel>
                <FormControl>
                  <Input
                    placeholder={
                      CheckoutAddressFormMetadata.lastName.placeholder
                    }
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  {CheckoutAddressFormMetadata.lastName.description}
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />
        </div>

        <div className="flex w-full gap-5">
          <div className="flex grow">
            <div className="w-full">
              <InputCombobox
                name="countryArea"
                form={form}
                label={CheckoutAddressFormMetadata.countryArea.label}
                placeholder={
                  CheckoutAddressFormMetadata.countryArea.placeholder
                }
                description={
                  CheckoutAddressFormMetadata.countryArea.description
                }
                notFoundMessage="Sehir bulunamadi"
                items={[
                  { label: "Istanbul", value: "IST" },
                  { label: "Ankara", value: "ANK" },
                  { label: "Izmir", value: "IZM" },
                ]}
              />
            </div>
          </div>

          <div className="flex grow">
            <div className="w-full">
              <InputCombobox
                name="district"
                form={form}
                label={CheckoutAddressFormMetadata.district.label}
                placeholder={CheckoutAddressFormMetadata.district.placeholder}
                description={CheckoutAddressFormMetadata.district.description}
                notFoundMessage="Sehir bulunamadi"
                items={[
                  { label: "Istanbul", value: "IST" },
                  { label: "Ankara", value: "ANK" },
                  { label: "Izmir", value: "IZM" },
                ]}
              />
            </div>
          </div>
        </div>

        <div className="flex w-full">
          <FormField
            control={form.control}
            name="streetAddress1"
            render={({ field }) => (
              <FormItem className="w-full">
                <FormLabel>
                  {CheckoutAddressFormMetadata.streetAddress1.label}
                </FormLabel>
                <FormControl>
                  <Input
                    placeholder={
                      CheckoutAddressFormMetadata.streetAddress1.placeholder
                    }
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  {CheckoutAddressFormMetadata.streetAddress1.description}
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />
        </div>

        <div className="flex w-full">
          <FormField
            control={form.control}
            name="streetAddress2"
            render={({ field }) => (
              <FormItem className="w-full">
                <FormLabel>
                  {CheckoutAddressFormMetadata.streetAddress2.label}
                </FormLabel>
                <FormControl>
                  <Input
                    placeholder={
                      CheckoutAddressFormMetadata.streetAddress2.placeholder
                    }
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  {CheckoutAddressFormMetadata.streetAddress2.description}
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />
        </div>

        <div className="flex w-full">
          <FormField
            control={form.control}
            name="postalCode"
            render={({ field }) => (
              <FormItem className="w-full">
                <FormLabel>
                  {CheckoutAddressFormMetadata.postalCode.label}
                </FormLabel>
                <FormControl>
                  <Input
                    placeholder={
                      CheckoutAddressFormMetadata.postalCode.placeholder
                    }
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  {CheckoutAddressFormMetadata.postalCode.description}
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />
        </div>

        <div className="flex grow gap-5">
          <Button
            className="flex grow"
            type="button"
            onClick={async () => {
              await props.cancelAction();
            }}
            variant="outline"
          >
            Geri
          </Button>
          <Button className="flex grow" type="submit">
            Ileri
          </Button>
        </div>
      </form>
    </Form>
  );
}
