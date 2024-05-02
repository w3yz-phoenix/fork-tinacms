import { TinaNodeBackend, LocalBackendAuthProvider } from "@tinacms/datalayer";
import { AuthJsBackendAuthProvider, TinaAuthJSOptions } from "tinacms-authjs";

import databaseClient from "../../../../tina/__generated__/databaseClient";
import type { NextApiRequest, NextApiResponse } from "next";

const isLocal = process.env.TINA_PUBLIC_IS_LOCAL === "true";

const handler = TinaNodeBackend({
  authProvider: isLocal
    ? LocalBackendAuthProvider()
    : AuthJsBackendAuthProvider({
        authOptions: TinaAuthJSOptions({
          databaseClient: databaseClient,
          secret: process.env.NEXTAUTH_SECRET ?? "secret",
        }),
      }),
  databaseClient,
});

export default (req: NextApiRequest, res: NextApiResponse) => {
  // Dirty hack to get around the fact that the TinaCMS GraphQL API doesn't accept empty variables
  if (req.body && req.body.query && !req.body.variables) {
    req.body.variables = {};
  }
  // Modify the request here if you need to
  return handler(req, res);
};
