"use client";

import {
  Breadcrumb,
  BreadcrumbList,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbSeparator,
} from "#shadcn/components/breadcrumb";
import { cn } from "#shadcn/lib/utils";
import _ from "lodash";
import Link from "next/link";
import { usePathname } from "next/navigation";
import React from "react";

export function DynamicBreadcrumb() {
  const paths = usePathname();
  const pathNames = paths
    .split("/")
    .filter((path) => path)
    .map((path) => ({
      href: `/${path}`,
      label: _.startCase(path),
    }));

  const allPaths = [{ href: "/", label: "Dashboard" }, ...pathNames];
  return (
    <Breadcrumb className="hidden md:flex">
      <BreadcrumbList>
        {allPaths.map(({ href, label }, index) => (
          <React.Fragment key={href}>
            <BreadcrumbItem>
              <BreadcrumbLink asChild>
                <Link href={href}>{label}</Link>
              </BreadcrumbLink>
            </BreadcrumbItem>
            <BreadcrumbSeparator
              className={cn("mx-2", {
                hidden: index === allPaths.length - 1,
              })}
            />
          </React.Fragment>
        ))}
      </BreadcrumbList>
    </Breadcrumb>
  );
}
