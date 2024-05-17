"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useRouter } from "next/navigation";
import { useForm } from "react-hook-form";
import { z } from "zod";

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

import {
  ProfileAddressFormMetadata,
  ProfileAddressFormSchema,
  ProfileAddressFormType,
} from "./schemas";
import { InputCombobox } from "./combobox";

export function ProfileAddressForm(props: {
  values?: Partial<ProfileAddressFormType>;
  completeAction: (
    data: ProfileAddressFormType
  ) => Promise<{ success?: boolean; error?: string } | undefined>;
  cancelAction: () => unknown;
}) {
  const router = useRouter();
  const form = useForm<z.infer<typeof ProfileAddressFormSchema>>({
    resolver: zodResolver(ProfileAddressFormSchema),
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

          router.push("/profile/address");
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
                  {ProfileAddressFormMetadata.firstName.label}
                </FormLabel>
                <FormControl>
                  <Input
                    placeholder={
                      ProfileAddressFormMetadata.firstName.placeholder
                    }
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  {ProfileAddressFormMetadata.firstName.description}
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="phone"
            render={({ field }) => (
              <FormItem className="w-1/2">
                <FormLabel>{ProfileAddressFormMetadata.phone.label}</FormLabel>
                <FormControl>
                  <Input
                    placeholder={ProfileAddressFormMetadata.phone.placeholder}
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  {ProfileAddressFormMetadata.phone.description}
                </FormDescription>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="email"
            render={({ field }) => (
              <FormItem className="w-1/2">
                <FormLabel>{ProfileAddressFormMetadata.email.label}</FormLabel>
                <FormControl>
                  <Input
                    placeholder={ProfileAddressFormMetadata.email.placeholder}
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  {ProfileAddressFormMetadata.email.description}
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
                  {ProfileAddressFormMetadata.lastName.label}
                </FormLabel>
                <FormControl>
                  <Input
                    placeholder={
                      ProfileAddressFormMetadata.lastName.placeholder
                    }
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  {ProfileAddressFormMetadata.lastName.description}
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
                label={ProfileAddressFormMetadata.countryArea.label}
                placeholder={ProfileAddressFormMetadata.countryArea.placeholder}
                description={ProfileAddressFormMetadata.countryArea.description}
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
                label={ProfileAddressFormMetadata.district.label}
                placeholder={ProfileAddressFormMetadata.district.placeholder}
                description={ProfileAddressFormMetadata.district.description}
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
                  {ProfileAddressFormMetadata.streetAddress1.label}
                </FormLabel>
                <FormControl>
                  <Input
                    placeholder={
                      ProfileAddressFormMetadata.streetAddress1.placeholder
                    }
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  {ProfileAddressFormMetadata.streetAddress1.description}
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
                  {ProfileAddressFormMetadata.streetAddress2.label}
                </FormLabel>
                <FormControl>
                  <Input
                    placeholder={
                      ProfileAddressFormMetadata.streetAddress2.placeholder
                    }
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  {ProfileAddressFormMetadata.streetAddress2.description}
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
                  {ProfileAddressFormMetadata.postalCode.label}
                </FormLabel>
                <FormControl>
                  <Input
                    placeholder={
                      ProfileAddressFormMetadata.postalCode.placeholder
                    }
                    {...field}
                  />
                </FormControl>
                <FormDescription>
                  {ProfileAddressFormMetadata.postalCode.description}
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
            Vazgec
          </Button>
          <Button className="flex grow" type="submit">
            Kaydet
          </Button>
        </div>
      </form>
    </Form>
  );
}
