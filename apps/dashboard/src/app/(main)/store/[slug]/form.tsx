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
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from "#shadcn/components/card";
import {
  StoreFormMetadata,
  StoreFormSchema,
  type StoreFormType,
} from "./schemas";
import { toast } from "#shadcn/components/use-toast";

export function StoreForm(props: {
  values?: Partial<StoreFormType>;
  completeAction: (
    data: StoreFormType
  ) => Promise<{ success?: boolean } | undefined>;
  cancelAction: () => Promise<void>;
}) {
  const router = useRouter();
  const form = useForm<StoreFormType>({
    resolver: zodResolver(StoreFormSchema),
    defaultValues: {
      name: props.values?.name ?? "",
      slug: props.values?.slug ?? "",
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
              description: "Hata olustu",
              variant: "destructive",
            });
            return;
          }

          response?.success && router.push("/store");
        })}
        className="flex flex-col gap-5 grow"
      >
        <Card x-chunk="dashboard-04-chunk-1">
          <CardHeader>
            <CardTitle>Magaza Ayarlari</CardTitle>
            <CardDescription>
              Used to identify your store in the marketplace.
            </CardDescription>
          </CardHeader>
          <CardContent className="flex flex-col gap-5 grow">
            {Object.keys(StoreFormMetadata).map((name: string) => {
              const metadata =
                StoreFormMetadata[name as keyof typeof StoreFormMetadata];

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
          </CardContent>
          <CardFooter className="px-6 py-4 border-t">
            <div className="flex gap-5 grow">
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
          </CardFooter>
        </Card>
      </form>
    </Form>
  );
}
