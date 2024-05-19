import Link from "next/link";

import { safeJsonParse } from "@w3yz/tools/lib";
import { cookies } from "next/headers";
import { redirect } from "next/navigation";

import { setCookie } from "#dashboard/lib/actions/actions.server";
import { createOrUpdateStore, createStore } from "#dashboard/lib/store/api";
import { StoreForm } from "./form";
import {
  storeFormCookieName,
  StoreFormSchema,
  type StoreFormType,
} from "./schemas";

export default async function EditStorePage(props: {
  params: { slug: string };
}) {
  const isCreating = props.params.slug === "create";

  const cookieValidation = await StoreFormSchema.safeParseAsync(
    safeJsonParse(cookies().get(storeFormCookieName)?.value)
  );

  const existingFormValues = cookieValidation.success
    ? cookieValidation.data
    : {
        name: "",
        slug: "",
      };

  async function submitStore(params: StoreFormType) {
    "use server";

    try {
      const validation = await StoreFormSchema.spa(params);

      if (!validation.success) {
        return {
          success: false,
          validationError: validation.error.format(),
        };
      }

      const { name, slug } = validation.data;

      setCookie(
        storeFormCookieName,
        JSON.stringify({
          name,
          slug,
        })
      );

      const newStore = await createOrUpdateStore({
        name,
        slug,
      });

      console.log(newStore);

      setCookie(storeFormCookieName);

      return {
        success: true,
      };
    } catch (error) {
      console.error(error);

      return {
        success: false,
        error: (error as any).message,
      };
    }
  }

  async function goBack() {
    "use server";

    setCookie(storeFormCookieName);

    redirect("/store");
  }

  return (
    <div className="flex flex-col w-full min-h-screen">
      <main className="flex min-h-[calc(100vh_-_theme(spacing.16))] flex-1 flex-col gap-4 bg-muted/40 p-4 md:gap-8 md:p-10">
        <div className="grid w-full max-w-6xl gap-2 mx-auto">
          <h1 className="text-3xl font-semibold">Settings</h1>
        </div>
        <div className="mx-auto grid w-full max-w-6xl items-start gap-6 md:grid-cols-[180px_1fr] lg:grid-cols-[250px_1fr]">
          <nav
            className="grid gap-4 text-sm text-muted-foreground"
            x-chunk="dashboard-04-chunk-0"
          >
            <Link href="#" className="font-semibold text-primary">
              General
            </Link>
            <Link href="#">Branding</Link>
            <Link href="#">Advanced</Link>
          </nav>
          <div className="grid gap-6">
            <StoreForm
              values={existingFormValues}
              cancelAction={goBack}
              completeAction={submitStore}
            />
          </div>
        </div>
      </main>
    </div>
  );
}
