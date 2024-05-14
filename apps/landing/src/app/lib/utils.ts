import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export { cva } from "class-variance-authority";
export type { VariantProps as VariantProperties } from "class-variance-authority";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export const isPresent = <T>(v: T | null | undefined): v is T =>
  v !== undefined && v !== null;
