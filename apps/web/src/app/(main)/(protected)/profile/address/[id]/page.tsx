import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";
import { invariant } from "@w3yz/tools/lib";
import { z } from "zod";
import { useCurrentUserAddressCreateMutation } from "@w3yz/ecom/api";

import { ProfileAddressForm } from "../form";
import {
  DefaultProfileAddressFormValues,
  ProfileAddressFormSchema,
} from "../schemas";

async function goBack() {
  "use server";

  redirect("/profile/address");
}

export type ProfileAddressFormType = z.infer<typeof ProfileAddressFormSchema>;

// const AddressDetailsQuery = graphql(`
//   query AddressDetails($id: ID!) {
//     address(id: $id) {
//       ...AddressFragment
//     }
//   }
// `);

async function submitNewAccountAddressForm(params: ProfileAddressFormType) {
  "use server";

  try {
    const validation = await ProfileAddressFormSchema.safeParseAsync(params);

    if (!validation.success) {
      return {
        success: false,
        error: "Form validation failed",
      };
    }
    useCurrentUserAddressCreateMutation.fetcher({
      address: validation.data,
    });

    return {
      success: true,
    };
  } catch (error) {
    return {
      success: false,
      error: console.error(error),
    };
  }
}
async function updateAccountAddress(
  params: ProfileAddressFormType,
  id: string
) {
  "use server";

  try {
    const validation = await ProfileAddressFormSchema.safeParseAsync(params);

    if (!validation.success) {
      return {
        success: false,
        error: "Form validation failed",
      };
    }
    useCurrentUserAddressUpdateMutation.fetcher({
      id: id,
      address: validation.data,
    });

    return {
      success: true,
    };
  } catch (error) {
    return {
      success: false,
      error: console.error(error),
    };
  }
}

export default async function ProfileAddressEditPage(props: {
  params: { id: "create" | string };
}) {
  if (props.params.id === "create") {
    return (
      <ProfileAddressForm
        values={DefaultProfileAddressFormValues}
        cancelAction={goBack}
        completeAction={submitNewAccountAddressForm}
      />
    );
  }

  const address = await useAddressDetailsQuery.fetcher({
    id: props.params.id,
  });

  return (
    <ProfileAddressForm
      completeAction={updateAccountAddress}
      values={address}
      cancelAction={goBack}
    />
  );
}
