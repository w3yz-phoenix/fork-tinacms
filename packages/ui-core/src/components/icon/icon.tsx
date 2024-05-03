import * as TablerIcons from "@tabler/icons-react";

import type { ObjectField } from "@tinacms/schema-tools";

export const iconSchema: ObjectField = {
  type: "object",
  label: "Icon",
  name: "icon",
};

console.log("iconSchema:", iconSchema);
