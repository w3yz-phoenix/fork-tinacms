import { z } from "zod";

export const privateEnvironment = z
  .object({
    NODE_ENV: z.string().default("development"),
    RESEND_API_KEY: z.string().optional(),
  })
  .transform((data) => ({
    _env: data,
    isDevelopment: data.NODE_ENV === "development",
    isProduction: data.NODE_ENV === "production",
    isTest: data.NODE_ENV === "test",
    resendApiKey: data.RESEND_API_KEY,
  }))
  .parse({
    NODE_ENV: process.env.NODE_ENV,
    RESEND_API_KEY: process.env.RESEND_API_KEY,
  });

export const publicEnvironment = z
  .object({
    NEXT_PUBLIC_ECOM_API_URL: z.string().url(),
    NEXT_PUBLIC_ECOM_URL: z.string().url(),
    NEXT_PUBLIC_ECOM_NAME: z.string().default("W3YZ Shop"),
    NEXT_PUBLIC_CMS_API_URL: z.string().url(),
  })
  .transform((data) => ({
    _env: data,
    ecom: {
      url: data.NEXT_PUBLIC_ECOM_URL,
      name: data.NEXT_PUBLIC_ECOM_NAME,
      api: data.NEXT_PUBLIC_ECOM_API_URL,
      https: data.NEXT_PUBLIC_ECOM_URL.startsWith("https"),
    },
    cms: {
      api: data.NEXT_PUBLIC_CMS_API_URL,
    },
  }))
  .parse({
    NEXT_PUBLIC_ECOM_API_URL: process.env.NEXT_PUBLIC_ECOM_API_URL,
    NEXT_PUBLIC_ECOM_URL: process.env.NEXT_PUBLIC_ECOM_URL,
    NEXT_PUBLIC_ECOM_NAME: process.env.NEXT_PUBLIC_ECOM_NAME,
    NEXT_PUBLIC_CMS_API_URL: process.env.NEXT_PUBLIC_CMS_API_URL,
  });
