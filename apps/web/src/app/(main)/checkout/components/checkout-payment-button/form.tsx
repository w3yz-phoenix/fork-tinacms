"use client";

import { Button } from "#shadcn/components/button";
import { Checkbox } from "#shadcn/components/checkbox";
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
} from "#shadcn/components/form";
import { zodResolver } from "@hookform/resolvers/zod";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useForm } from "react-hook-form";
import Image from "next/image";
import { toast } from "#shadcn/components/use-toast";

import IyzicoImageUrl from "./iyzico-white-banner.png";
import {
  CheckoutPaymentButtonFormSchema,
  type CheckoutPaymentButtonFormType,
} from "./schemas";

export function CheckoutPaymentButtonForm(props: {
  values?: Partial<CheckoutPaymentButtonFormType>;
  completeAction: (
    data: CheckoutPaymentButtonFormType
  ) => Promise<{ success?: boolean } | undefined>;
  cancelAction: () => Promise<void>;
}) {
  const router = useRouter();
  const form = useForm<CheckoutPaymentButtonFormType>({
    resolver: zodResolver(CheckoutPaymentButtonFormSchema),
    defaultValues: {
      ...CheckoutPaymentButtonFormSchema.safeParse(props.values)?.data,
    },
  });

  const { contractChecked, termsChecked } = form.watch();
  const disabled = !contractChecked || !termsChecked;

  return (
    <Form {...form}>
      <form
        onSubmit={form.handleSubmit(async (data) => {
          const response = await props.completeAction(data);
          if (!response?.success) {
            toast({
              title: "Odeme isleminiz basarisiz oldu, lutfen tekrar deneyin.",
              variant: "destructive",
            });
            console.error(response);
            return;
          }

          toast({
            title:
              "Odeme isleminiz basariyla baslatildi, birazdan yonlendirileceksiniz.",
          });

          router.push("/redirect");
        })}
        className="mt-10 flex grow flex-col gap-8"
      >
        <FormField
          control={form.control}
          name="termsChecked"
          render={({ field }) => (
            <FormItem className="flex flex-row items-start space-x-3 space-y-0">
              <FormControl>
                <Checkbox
                  checked={field.value}
                  onCheckedChange={field.onChange}
                />
              </FormControl>
              <div className="space-y-1 leading-none">
                <FormLabel>
                  On bilgilendirme kosullarini okudum ve kabul ediyorum.
                </FormLabel>
                <FormDescription>
                  <span>{`Sozlesme metni icin `}</span>
                  <strong>
                    <Link
                      target="_blank"
                      href="/custom/legal/on-bilgilendirme-kosullari"
                    >
                      tiklayiniz
                    </Link>
                  </strong>
                  <span>.</span>
                </FormDescription>
              </div>
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="contractChecked"
          render={({ field }) => (
            <FormItem className="flex flex-row items-start space-x-3 space-y-0">
              <FormControl>
                <Checkbox
                  checked={field.value}
                  onCheckedChange={field.onChange}
                />
              </FormControl>
              <div className="space-y-1 leading-none">
                <FormLabel>
                  Mesafeli satis sozlesmesini okudum ve kabul ediyorum.
                </FormLabel>
                <FormDescription>
                  <span>{`Sozlesme metni icin `}</span>
                  <strong>
                    <Link
                      target="_blank"
                      href="/custom/legal/mesafeli-satis-sozlesmesi"
                    >
                      tiklayiniz
                    </Link>
                  </strong>
                  <span>.</span>
                </FormDescription>
              </div>
            </FormItem>
          )}
        />

        <Button
          type="submit"
          disabled={disabled}
          className="mb-3 flex w-full items-center justify-center rounded-lg bg-[#00C48C] py-3 font-medium hover:bg-[#008362] disabled:bg-[#A0FAD5]"
        >
          <Image
            src={IyzicoImageUrl}
            alt="iyzico ödeme"
            height={50}
            width={135}
          />
        </Button>
      </form>
    </Form>
  );
}
