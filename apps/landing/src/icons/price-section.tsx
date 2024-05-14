import { FC, SVGProps } from "react";

export const IconOk: FC<SVGProps<SVGSVGElement>> = (props) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width={16}
    height={16}
    fill="none"
    {...props}
  >
    <path
      fill="#2E735F"
      d="M7.833 15.5a7.5 7.5 0 1 1 0-15 7.5 7.5 0 0 1 0 15ZM7.087 11l5.302-5.303-1.06-1.06-4.242 4.242-2.122-2.122-1.06 1.06L7.085 11Z"
    />
  </svg>
);

export const IconFalse: FC<SVGProps<SVGSVGElement>> = (props) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width={16}
    height={16}
    fill="none"
    {...props}
  >
    <path
      fill="#942525"
      d="M7.833 15.5a7.5 7.5 0 1 1 0-15 7.5 7.5 0 0 1 0 15Zm0-8.56-2.12-2.122L4.65 5.879 6.773 8l-2.122 2.121 1.062 1.061 2.12-2.122 2.121 2.122 1.062-1.061L8.894 8l2.122-2.121-1.062-1.061-2.12 2.122Z"
    />
  </svg>
);
