import { invariant } from "ts-invariant";

invariant(
  process.env.LANDING_RESEND_API_KEY,
  "Missing LANDING_RESEND_API_KEY env variable"
);

export const resendApiKey = process.env.LANDING_RESEND_API_KEY;
