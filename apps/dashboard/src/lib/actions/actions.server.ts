import { publicEnvironment } from "@w3yz/tools/environment";
import { cookies } from "next/headers";

export const setCookie = (name: string, value?: string) => {
  if (!value) {
    cookies().delete(name);
    return;
  }

  cookies().set(name, value, {
    secure: publicEnvironment.ecom.https,
    sameSite: "lax",
    httpOnly: true,
    maxAge: 60 * 60 * 24,
  });
};
