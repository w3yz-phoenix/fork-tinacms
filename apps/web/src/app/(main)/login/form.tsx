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
  LoginFormMetadata,
  LoginFormSchema,
  type LoginFormType,
} from "./schemas";

export function LoginForm(props: {
  values?: Partial<LoginFormType>;
  completeAction: (
    data: LoginFormType
  ) => Promise<{ success?: boolean } | undefined>;
  cancelAction: () => Promise<void>;
}) {
  const router = useRouter();
  const form = useForm<LoginFormType>({
    resolver: zodResolver(LoginFormSchema),
    defaultValues: {
      email: props.values?.email ?? "",
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
                Giriş Yap
              </h1>
              <p className="lg:text-[20px]">
                Tekrar hoş geldiniz, giriş yapın.
              </p>
            </div>
            <Form {...form}>
              <form
                onSubmit={form.handleSubmit(async (data) => {
                  const response = await props.completeAction(data);
                  response?.success && router.push("/");
                })}
                className="flex grow flex-col gap-5"
              >
                <div className="flex w-full">
                  <FormField
                    control={form.control}
                    name="email"
                    render={({ field }) => (
                      <FormItem className="w-full">
                        <FormLabel>{LoginFormMetadata.email.label}</FormLabel>
                        <FormControl>
                          <Input
                            placeholder={LoginFormMetadata.email.placeholder}
                            {...field}
                          />
                        </FormControl>
                        <FormDescription>
                          {LoginFormMetadata.email.description}
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
                          {LoginFormMetadata.password.label}
                        </FormLabel>
                        <FormControl>
                          <InputPassword
                            type="password"
                            placeholder={LoginFormMetadata.password.placeholder}
                            {...field}
                          />
                        </FormControl>
                        <FormDescription>
                          {LoginFormMetadata.password.description}
                        </FormDescription>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>
                <div className="mt-2 flex flex-col gap-4">
                  <Button
                    className="flex h-12 w-full items-center justify-center gap-2 rounded-lg bg-green-300 px-3 py-1.5 text-2xl font-medium leading-normal text-white hover:bg-green-700 disabled:bg-green-200 "
                    type="submit"
                    variant="outline"
                  >
                    Giriş Yap
                  </Button>
                </div>
                <div className="text-[14px] text-[#676870]">
                  Hesabınız yok mu?
                  <Link
                    href="/register"
                    className="text-[14px] font-medium text-[#252627]"
                  >
                    {" "}
                    Kayıt Ol
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
