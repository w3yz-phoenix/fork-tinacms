import { z } from "zod";

export const GenericResponseSchema = z
  .object({
    success: z.boolean(),
    message: z.string().optional(),
    iteration: z.number().default(1).optional(),
  })
  .optional();

export type GenericResponse = z.infer<typeof GenericResponseSchema>;
