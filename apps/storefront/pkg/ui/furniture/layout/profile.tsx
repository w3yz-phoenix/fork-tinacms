import Link from "next/link";
import { IconUser } from "@tabler/icons-react";

import type { TinaGraphql_GlobalConfigHeaderLinksProfile } from "@w3yz/cms/api";

type ProfileProps = {
  block: TinaGraphql_GlobalConfigHeaderLinksProfile;
  "data-tina-field"?: string;
};

export const Profile = (props: ProfileProps) => {
  return (
    <Link href={"/profile"} data-tina-field={props["data-tina-field"]}>
      <IconUser />
    </Link>
  );
};
