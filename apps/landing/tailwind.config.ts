/* eslint-disable unicorn/prefer-module */
import * as path from "node:path";

import { mainTailwindConfig } from "@w3yz/tailwind/main-config";
import defaultTheme from "tailwindcss/defaultTheme";

import type { Config } from "tailwindcss";

const config: Pick<Config, "presets" | "theme"> = {
  presets: [
    mainTailwindConfig({
      content: [path.resolve(__dirname, "./src/**/*.{js,ts,jsx,tsx,mdx}")],
    }),
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: [
          "var(--font-poppins)",
          "Poppins",
          ...defaultTheme.fontFamily.sans,
        ],
        serif: [
          "var(--font-poppins)",
          "Poppins",
          ...defaultTheme.fontFamily.serif,
        ],
        poppins: ["var(--font-poppins)", "sans-serif"],
        suisse: ["var(--font-suisse)", "sans-serif"],
      },
    },
  },
};

export default config;
