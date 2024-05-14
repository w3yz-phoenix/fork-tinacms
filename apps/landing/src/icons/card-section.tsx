import { FC, SVGProps } from "react";

export const CardSectionRight: FC<SVGProps<SVGSVGElement>> = (props) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width={115}
    height={137}
    fill="none"
    {...props}
  >
    <path
      stroke="#9D95FF"
      strokeLinecap="round"
      strokeMiterlimit={10}
      strokeWidth={6.139}
      d="M4 95.243C12.491 76.522 30.375 60.1 50.91 61.238c18.113.992 33.568 15.96 38.86 33.308 4.595 15.056-.435 35.426-15.789 38.714-15.353 3.289-28.168-12.651-32.179-27.835-6.067-22.766-1.582-47.987 11.93-67.229C67.247 18.955 89.463 6.076 112.906 4"
    />
  </svg>
);
export const CardSectionLeft: FC<SVGProps<SVGSVGElement>> = (props) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width={62}
    height={62}
    fill="none"
    {...props}
  >
    <g clipPath="url(#a)">
      <path
        fill="url(#b)"
        d="M28.077 1.89a4.133 4.133 0 0 1 5.846 0L60.11 28.076a4.133 4.133 0 0 1 0 5.846L33.923 60.11a4.133 4.133 0 0 1-5.846 0L1.89 33.923a4.133 4.133 0 0 1 0-5.846L28.077 1.89Z"
      />
    </g>
    <defs>
      <linearGradient
        id="b"
        x1={-36.892}
        x2={76.898}
        y1={-8.444}
        y2={36.259}
        gradientUnits="userSpaceOnUse"
      >
        <stop offset={0.427} stopColor="#FF8709" />
        <stop offset={0.792} stopColor="#F7BDF8" />
      </linearGradient>
      <clipPath id="a">
        <path fill="#fff" d="M0 0h62v62H0z" />
      </clipPath>
    </defs>
  </svg>
);
