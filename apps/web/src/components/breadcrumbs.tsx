import Link from "next/link";

import { cn } from "#shadcn/lib/utils";

type BreadcrumbsProperties = {
  className?: string;
  breadcrumbs: {
    label: string;
    canonicalPath: string;
  }[];
};

export function Breadcrumbs({ className, breadcrumbs }: BreadcrumbsProperties) {
  return (
    <div
      className={cn(
        "flex flex-wrap gap-2.5 text-base text-[#83878D] sm:text-xl",
        className
      )}
    >
      {breadcrumbs.map((item, index) => (
        <div key={index}>
          <Link
            href={item.canonicalPath}
            className={`group whitespace-nowrap  ${
              index === breadcrumbs.length - 1
                ? "font-medium text-[#4C4F52]"
                : ""
            }`}
          >
            {item.label}
          </Link>
          {index !== breadcrumbs.length - 1 && <span> / </span>}
        </div>
      ))}
    </div>
  );
}
