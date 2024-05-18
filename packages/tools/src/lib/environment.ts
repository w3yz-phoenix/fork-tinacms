import { z } from "zod";

export const privateEnvironment = z
  .object({
    NODE_ENV: z.string().default("development"),
    LANDING_RESEND_API_KEY: z.string().optional(),
  })
  .transform((data) => ({
    _env: data,
    isDevelopment: data.NODE_ENV === "development",
    isProduction: data.NODE_ENV === "production",
    isTest: data.NODE_ENV === "test",
    resendApiKey: data.LANDING_RESEND_API_KEY,
  }))
  .parse({
    NODE_ENV: process.env.NODE_ENV,
    LANDING_RESEND_API_KEY: process.env.LANDING_RESEND_API_KEY,
  });

export const publicEnvironment = z
  .object({
    NEXT_PUBLIC_URL: z.string().url(),
    NEXT_PUBLIC_ECOM_API_URL: z.string().url(),
    NEXT_PUBLIC_ECOM_NAME: z.string().default("W3YZ Shop"),
    NEXT_PUBLIC_CMS_BASE_URL: z.string().url(),
  })
  .transform((data) => ({
    _env: data,
    ecom: {
      url: data.NEXT_PUBLIC_URL,
      name: data.NEXT_PUBLIC_ECOM_NAME,
      api: data.NEXT_PUBLIC_ECOM_API_URL,
      https: data.NEXT_PUBLIC_URL.startsWith("https"),
    },
    cms: {
      base: data.NEXT_PUBLIC_CMS_BASE_URL,
      admin: `${data.NEXT_PUBLIC_CMS_BASE_URL}/admin`,
      graphql: `${data.NEXT_PUBLIC_CMS_BASE_URL}/api/tina/gql`,
    },
  }))
  .parse({
    NEXT_PUBLIC_URL: process.env.NEXT_PUBLIC_URL,
    NEXT_PUBLIC_ECOM_API_URL: process.env.NEXT_PUBLIC_ECOM_API_URL,
    NEXT_PUBLIC_ECOM_NAME: process.env.NEXT_PUBLIC_ECOM_NAME,
    NEXT_PUBLIC_CMS_BASE_URL: process.env.NEXT_PUBLIC_CMS_BASE_URL,
  });
