import { invariant } from "ts-invariant";

invariant(process.env.RESEND_API_KEY, "Missing RESEND_API_KEY env variable");

export const resendApiKey = process.env.RESEND_API_KEY;
