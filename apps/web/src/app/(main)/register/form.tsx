"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import { useRouter } from "next/navigation";
import Image from "next/image";
import Link from "next/link";

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
import { InputPassword } from "#shadcn/components/input-password";

import loginPageBg from "./homeBlog1.png";
import {
  RegisterFormMetadata,
  RegisterFormSchema,
  type RegisterFormType,
} from "./schemas";

export function RegisterForm(props: {
  values?: Partial<RegisterFormType>;
  completeAction: (
    data: RegisterFormType
  ) => Promise<{ success?: boolean } | undefined>;
  cancelAction: () => Promise<void>;
}) {
  const router = useRouter();
  const form = useForm<RegisterFormType>({
    resolver: zodResolver(RegisterFormSchema),
    defaultValues: {
      firstName: props.values?.firstName ?? "",
      lastName: props.values?.lastName ?? "",
      email: props.values?.email ?? "",
      phone: props.values?.phone ?? "",
      password: props.values?.password ?? "",
    },
  });

  return (
    <div className="flex flex-col-reverse text-gray-950 lg:h-dvh lg:flex-row ">
      <div className="flex-1">
        <div className="flex grow lg:h-screen">
          <div className="mx-6 my-8 flex w-full flex-col gap-5 sm:mx-auto sm:my-20 sm:w-[600px] lg:my-auto lg:w-[395px]">
            <div className="mb-6 lg:mb-8">
              <h1 className="mb-2 text-[24px] font-bold lg:mb-4 lg:text-4xl">
                Hesap Oluştur
              </h1>
              <p className="lg:text-[20px]">
                Bir hesap oluşturun ve giriş yapın.
              </p>
            </div>
            <Form {...form}>
              <form
                onSubmit={form.handleSubmit(async (data) => {
                  const response = await props.completeAction(data);
                  response?.success && router.push("/login");
                })}
                className="flex grow flex-col gap-5"
              >
                <div className="flex gap-5">
                  <FormField
                    control={form.control}
                    name="firstName"
                    render={({ field }) => (
                      <FormItem className="w-1/2">
                        <FormLabel>
                          {RegisterFormMetadata.firstName.label}
                        </FormLabel>
                        <FormControl>
                          <Input
                            placeholder={
                              RegisterFormMetadata.firstName.placeholder
                            }
                            {...field}
                          />
                        </FormControl>
                        <FormDescription>
                          {RegisterFormMetadata.firstName.description}
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
                          {RegisterFormMetadata.lastName.label}
                        </FormLabel>
                        <FormControl>
                          <Input
                            placeholder={
                              RegisterFormMetadata.lastName.placeholder
                            }
                            {...field}
                          />
                        </FormControl>
                        <FormDescription>
                          {RegisterFormMetadata.lastName.description}
                        </FormDescription>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <div className="flex w-full">
                  <FormField
                    control={form.control}
                    name="email"
                    render={({ field }) => (
                      <FormItem className="w-full">
                        <FormLabel>
                          {RegisterFormMetadata.email.label}
                        </FormLabel>
                        <FormControl>
                          <Input
                            placeholder={RegisterFormMetadata.email.placeholder}
                            {...field}
                          />
                        </FormControl>
                        <FormDescription>
                          {RegisterFormMetadata.email.description}
                        </FormDescription>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <div className="flex w-full">
                  <FormField
                    control={form.control}
                    name="phone"
                    render={({ field }) => (
                      <FormItem className="w-full">
                        <FormLabel>
                          {RegisterFormMetadata.phone.label}
                        </FormLabel>
                        <FormControl>
                          <Input
                            placeholder={RegisterFormMetadata.phone.placeholder}
                            {...field}
                          />
                        </FormControl>
                        <FormDescription>
                          {RegisterFormMetadata.phone.description}
                        </FormDescription>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <div className="flex w-full">
                  <FormField
                    control={form.control}
                    name="password"
                    render={({ field }) => (
                      <FormItem className="w-full">
                        <FormLabel>
                          {RegisterFormMetadata.password.label}
                        </FormLabel>
                        <FormControl>
                          <InputPassword
                            type="password"
                            placeholder={
                              RegisterFormMetadata.password.placeholder
                            }
                            {...field}
                          />
                        </FormControl>
                        <FormDescription>
                          {RegisterFormMetadata.password.description}
                        </FormDescription>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>
                <label className="flex cursor-pointer select-none items-center gap-2">
                  <input
                    type="checkbox"
                    required
                    className="max-h-[16px] min-h-[16px] min-w-[16px] max-w-[16px] border border-[#CFD1D2] accent-[#EC8065]"
                  />
                  <p className="text-[16px] font-medium">
                    Üyelik Sözleşmesini ve KVKK Aydınlatma Metnini okudum, kabul
                    ediyorum.
                  </p>
                </label>
                <div className="mt-2 flex flex-col gap-4">
                  <Button
                    className="flex h-12 w-full items-center justify-center gap-2 rounded-lg bg-green-300 px-3 py-1.5 text-2xl font-medium leading-normal text-white hover:bg-green-700 disabled:bg-green-200 "
                    type="button"
                    onClick={async () => {
                      await props.cancelAction();
                    }}
                    variant="outline"
                  >
                    Kayıt Ol
                  </Button>
                </div>
                <div className="mx-auto my-3 text-sm ">
                  Zaten bir hesabın var mı?{" "}
                  <Link href="/login" className="font-bold">
                    Giriş Yap
                  </Link>
                </div>
              </form>
            </Form>
          </div>
        </div>
      </div>
      <div className="hidden flex-1 lg:block">
        <Image
          width={977}
          height={982}
          src={loginPageBg}
          alt="Login Page"
          className="size-full object-cover"
        />
      </div>
      <div className="block h-[150px] w-full flex-1 lg:hidden ">
        <Image
          width={430}
          height={120}
          src={loginPageBg}
          alt="Login Page"
          className="h-[150px] w-full object-cover"
        />
      </div>
    </div>
  );
}
