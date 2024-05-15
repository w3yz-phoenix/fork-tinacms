"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import { z } from "zod";

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
import { Button } from "#shadcn/components/button";

import {
  ProfilePasswordResetFormMetadata,
  ProfilePasswordResetFormSchema,
} from "./schemas";

export function ProfilePasswordResetForm() {
  const form = useForm<z.infer<typeof ProfilePasswordResetFormSchema>>({
    resolver: zodResolver(ProfilePasswordResetFormSchema),
  });

  return (
    <Form {...form}>
      <form className="min-h-[calc(100vh-495px)] lg:max-w-[872px] 2xl:mx-auto">
        <div className="mb-20 flex flex-col md:gap-0">
          <div>
            <div className="hidden md:block">
              <h2 className="mb-3 text-3xl font-semibold leading-[38px] text-[#101828]">
                Kişisel Bilgiler
              </h2>
              <p className="mb-4 text-base font-normal leading-normal text-[#656565] md:mb-8">
                Kişisel bilgilerinizi güncelleyin.
              </p>
            </div>

            <div className="mb-5 grid grid-cols-1 gap-5">
              {Object.keys(ProfilePasswordResetFormMetadata).map(
                (name: string) => {
                  const metadata =
                    ProfilePasswordResetFormMetadata[
                      name as keyof typeof ProfilePasswordResetFormMetadata
                    ];

                  return (
                    <FormField
                      key={metadata.name}
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>{metadata.label}</FormLabel>
                          <FormControl>
                            <Input
                              placeholder={metadata.placeholder}
                              {...field}
                            />
                          </FormControl>
                          {metadata.description && (
                            <FormDescription>
                              {metadata.description}
                            </FormDescription>
                          )}
                          <FormMessage />
                        </FormItem>
                      )}
                      name={metadata.name}
                    />
                  );
                }
              )}
            </div>
          </div>
          <div className="mb-8 flex flex-col justify-end gap-5 text-nowrap text-base font-medium text-white md:flex-row">
            <Button className="flex max-w-[200px] grow" type="submit">
              Güncelle
            </Button>
          </div>
        </div>
      </form>
    </Form>
  );
}
