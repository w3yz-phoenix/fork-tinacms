"use client";

import { Button } from "#shadcn/components/button";

export function DeleteButton(props: {
  action: (...args: any[]) => Promise<void>;
  disabled?: boolean;
}) {
  return (
    <Button
      variant="destructive"
      onClick={async (e) => {
        e.preventDefault();
        await props.action();
      }}
    >
      Delete
    </Button>
  );
}
