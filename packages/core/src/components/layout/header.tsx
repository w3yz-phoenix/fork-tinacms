"use client";

import {
  tinaField,
  useGlobalConfigQuery,
  useTinaQuery,
  type TinaGraphql_GlobalConfigQuery,
} from "@w3yz/cms-tina";

export const Header = ({ globalConfigPath }: { globalConfigPath: string }) => {
  const { globalConfig } = useTinaQuery<TinaGraphql_GlobalConfigQuery>(
    useGlobalConfigQuery,
    {
      relativePath: globalConfigPath,
    }
  );

  return (
    <div>
      <h1 data-tina-field={tinaField(globalConfig, "globalTitle")}>
        {globalConfig?.globalTitle}
      </h1>
    </div>
  );
};
