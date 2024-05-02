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
    NEXT_PUBLIC_SALEOR_API_URL: z.string().url(),
    NEXT_PUBLIC_STOREFRONT_URL: z.string().url(),
    NEXT_PUBLIC_STOREFRONT_NAME: z.string().default("W3YZ Shop"),
  })
  .transform((data) => ({
    _env: data,
    saleorEndpoint: data.NEXT_PUBLIC_SALEOR_API_URL,
    storefront: {
      url: data.NEXT_PUBLIC_STOREFRONT_URL,
      name: data.NEXT_PUBLIC_STOREFRONT_NAME,
    },
  }))
  .parse({
    NEXT_PUBLIC_SALEOR_API_URL: process.env.NEXT_PUBLIC_SALEOR_API_URL,
    NEXT_PUBLIC_STOREFRONT_URL: process.env.NEXT_PUBLIC_STOREFRONT_URL,
    NEXT_PUBLIC_STOREFRONT_NAME: process.env.NEXT_PUBLIC_STOREFRONT_NAME,
  });
