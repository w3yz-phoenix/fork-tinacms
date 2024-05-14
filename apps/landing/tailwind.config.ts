/* eslint-disable unicorn/prefer-module */
import TypographyPlugin from "@tailwindcss/typography";
import * as path from "node:path";

import defaultTheme from "tailwindcss/defaultTheme";

import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: ["class"],
  content: ["./src/**/*.{ts,tsx}"],
  plugins: [TypographyPlugin],
  theme: {
    container: {
      center: true,
      padding: "2rem",
    },
    screens: {
      ...defaultTheme.screens,
      xs: "393px",
      xss: "540px",
      "2xl": "1440px",
      "3xl": "1560px",
      "4xl": "1920px",
    },
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
      fontSize: {
        tiny: "0.625rem", // 10px
        xs: "0.6875rem", // 11px
        sm: "0.75rem", // 12px
        md: "0.8125rem", // 13px
        base: "0.8125rem", // 13px
        lg: "0.875rem", // 14px
        xl: "1rem", // 16px
        "2xl": "1.125rem", // 18px
        "3xl": "1.375rem", // 22px
        "4xl": "1.5rem", // 24px
        "5xl": "1.75rem", // 28px
        "6xl": "2rem", // 32px
        "7xl": "2.25rem", // 36px
        "8xl": "2.5rem", // 40px
        "9xl": "3rem", // 48px
        "10xl": "4rem", // 64px
        "11xl": "4.5rem", // 72px
      },
      colors: {
        blue: {
          "50": "#EFF5FF",
          "100": "#DFEAFF",
          "200": "#BDD5FF",
          "300": "#90BCFF",
          "400": "#5C97FE",
          "500": "#3670FB",
          "600": "#1F4FF1",
          "700": "#183ADD",
          "800": "#1A31B3",
          "900": "#1B2F8D",
          "950": "#151E56",
        },
        purple: {
          "50": "#F6F2FF",
          "100": "#EDE8FF",
          "200": "#DED4FF",
          "300": "#C6B1FF",
          "400": "#AA85FF",
          "500": "#9153FF",
          "600": "#8330F7",
          "700": "#751EE3",
          "800": "#6018BB",
          "900": "#52169C",
          "950": "#320B6A",
        },
        green: {
          "50": "#EDFCF2",
          "100": "#D2F9DE",
          "200": "#AAF0C4",
          "300": "#72E3A3",
          "400": "#3ACD7E",
          "500": "#16B364",
          "600": "#0A9150",
          "700": "#087442",
          "800": "#095C37",
          "900": "#094B2F",
          "950": "#032B1A",
        },
        red: {
          "50": "#FEF3F2",
          "100": "#FEE4E2",
          "200": "#FECECA",
          "300": "#FCACA5",
          "400": "#F87C71",
          "500": "#EF5244",
          "600": "#DC3526",
          "700": "#B9291C",
          "800": "#99251B",
          "900": "#7F251D",
          "950": "#450F0A",
        },
        yellow: {
          "50": "#FFF9DB",
          "100": "#FFF3BF",
          "200": "#FFEC99",
          "300": "#FFE066",
          "400": "#FFD43B",
          "500": "#FCC419",
          "600": "#FAB005",
          "700": "#F59F00",
          "800": "#F08C00",
          "900": "#E67700",
          "950": "#CF6B00",
        },
        orange: {
          "50": "#FFF4E6",
          "100": "#FFE8CC",
          "200": "#FFD8A8",
          "300": "#FFC078",
          "400": "#FFA94D",
          "500": "#FF922B",
          "600": "#FD7E14",
          "700": "#F76707",
          "800": "#E8590C",
          "900": "#D9480F",
          "950": "#B93400",
        },
        black: {
          "50": "#F6F6F6",
          "100": "#E7E7E7",
          "200": "#D1D1D1",
          "300": "#B1B1B1",
          "400": "#888888",
          "500": "#6D6D6D",
          "600": "#5D5D5D",
          "700": "#4F4F4F",
          "800": "#454545",
          "900": "#3D3D3D",
          "950": "#000000",
        },
        gray: {
          "50": "#F6F7F9",
          "100": "#EDEEF1",
          "200": "#D7DAE0",
          "300": "#B3B9C6",
          "400": "#8A94A6",
          "500": "#667085",
          "600": "#565E73",
          "700": "#464C5E",
          "800": "#3D424F",
          "900": "#363A44",
          "950": "#24262D",
        },
      },
    },
  },
};

export default config;
