import { z } from "zod";

const privateEnvironment = z
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

const publicEnvironment = z
  .object({
    NEXT_PUBLIC_URL: z.string().url(),
    NEXT_PUBLIC_ECOM_API_URL: z.string().url(),
    NEXT_PUBLIC_ECOM_NAME: z.string().default("W3YZ Shop"),
    NEXT_PUBLIC_CMS_BASE_URL: z.string().url(),
    NEXT_PUBLIC_CMS_CONTENT_ROOT_PATH: z.string().optional(),
    NEXT_PUBLIC_TINA_IS_LOCAL: z.string().optional(),
    TINA_PUBLIC_IS_LOCAL: z.string().optional(),
  })
  .transform((data) => {
    return {
      _env: data,
      ecom: {
        url: data.NEXT_PUBLIC_URL,
        name: data.NEXT_PUBLIC_ECOM_NAME,
        api: data.NEXT_PUBLIC_ECOM_API_URL,
        https: data.NEXT_PUBLIC_URL.startsWith("https"),
      },
      cms: {
        base: data.NEXT_PUBLIC_CMS_BASE_URL,
        contentRootPath: data.NEXT_PUBLIC_CMS_CONTENT_ROOT_PATH,
        admin: `${data.NEXT_PUBLIC_CMS_BASE_URL}/admin`,
        graphql: `${data.NEXT_PUBLIC_CMS_BASE_URL}/api/tina/gql`,
        isLocal:
          data.NEXT_PUBLIC_TINA_IS_LOCAL === "true" ||
          data.TINA_PUBLIC_IS_LOCAL === "true",
      },
    };
  })
  .parse({
    NEXT_PUBLIC_CMS_CONTENT_ROOT_PATH:
      process.env.NEXT_PUBLIC_CMS_CONTENT_ROOT_PATH,
    NEXT_PUBLIC_TINA_IS_LOCAL: process.env.NEXT_PUBLIC_TINA_IS_LOCAL,
    TINA_PUBLIC_IS_LOCAL: process.env.TINA_PUBLIC_IS_LOCAL,
    NEXT_PUBLIC_URL: process.env.NEXT_PUBLIC_URL,
    NEXT_PUBLIC_ECOM_API_URL: process.env.NEXT_PUBLIC_ECOM_API_URL,
    NEXT_PUBLIC_ECOM_NAME: process.env.NEXT_PUBLIC_ECOM_NAME,
    NEXT_PUBLIC_CMS_BASE_URL: process.env.NEXT_PUBLIC_CMS_BASE_URL,
  });

export const tinaEnvironment = {
  private: privateEnvironment,
  public: publicEnvironment,
};
