/* eslint-disable import/no-anonymous-default-export */
import { TinaNodeBackend, LocalBackendAuthProvider } from "@tinacms/datalayer";

import { TinaAuthJSOptions, AuthJsBackendAuthProvider } from "tinacms-authjs";

import databaseClient from "../../../tina/__generated__/databaseClient";
import { tinaEnvironment } from "../../lib/environment";

const handler = TinaNodeBackend({
  authProvider: tinaEnvironment.public.cms.isLocal
    ? LocalBackendAuthProvider()
    : AuthJsBackendAuthProvider({
        authOptions: TinaAuthJSOptions({
          databaseClient: databaseClient,
          secret: process.env.NEXTAUTH_SECRET!,
        }),
      }),
  databaseClient,
});

export default (req: any, res: any) => {
  // Modify the request here if you need to
  return handler(req, res);
};
