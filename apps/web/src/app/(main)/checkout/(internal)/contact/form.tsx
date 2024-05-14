"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import { useRouter } from "next/navigation";

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

import {
  CheckoutContactFormMetadata,
  CheckoutContactFormSchema,
  type CheckoutContactFormType,
} from "./schemas";

export function CheckoutContactForm(props: {
  values?: Partial<CheckoutContactFormType>;
  completeAction: (
    data: CheckoutContactFormType
  ) => Promise<{ success?: boolean } | undefined>;
  cancelAction: () => Promise<void>;
}) {
  const router = useRouter();
  const form = useForm<CheckoutContactFormType>({
    resolver: zodResolver(CheckoutContactFormSchema),
    defaultValues: {
      email: props.values?.email ?? "",
      phone: props.values?.phone ?? "",
    },
  });

  return (
    <Form {...form}>
      <form
        onSubmit={form.handleSubmit(async (data) => {
          const response = await props.completeAction(data);
          response?.success && router.push("/checkout/address");
        })}
        className="flex grow flex-col gap-5"
      >
        {Object.keys(CheckoutContactFormMetadata).map((name: string) => {
          const metadata =
            CheckoutContactFormMetadata[
              name as keyof typeof CheckoutContactFormMetadata
            ];

          return (
            <FormField
              key={metadata.name}
              control={form.control}
              name={metadata.name}
              render={({ field }) => (
                <FormItem>
                  <FormLabel>{metadata.label}</FormLabel>
                  <FormControl>
                    <Input placeholder={metadata.placeholder} {...field} />
                  </FormControl>
                  <FormDescription>{metadata.description}</FormDescription>
                  <FormMessage />
                </FormItem>
              )}
            />
          );
        })}

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
