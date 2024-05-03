import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@w3yz/ui-shadcn";
import * as RadixIcons from "@radix-ui/react-icons";

import { defineTinaField } from "../../lib/tina.utils";

export const getIconSchema = () => {
  return defineTinaField({
    type: "string",
    label: "Icon",
    name: "icon",
    searchable: true,
    ui: {
      component: () => {
        return (
          <Select>
            <SelectTrigger className="w-[180px]">
              <SelectValue placeholder="Icon" />
            </SelectTrigger>
            <SelectContent>
              {Object.entries(RadixIcons).map(([iconName, Icon]) => (
                <SelectItem key={iconName} value={iconName}>
                  <Icon className="size-6" />
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        );
      },
    },
  });
};
