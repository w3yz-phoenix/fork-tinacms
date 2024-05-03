/* eslint-disable unicorn/prefer-module */
/* eslint-disable import/no-anonymous-default-export */
import * as fs from "node:fs";
import path from "node:path";

import type { NextApiRequest, NextApiResponse } from "next";

export default async function blockRoute(
  req: NextApiRequest,
  res: NextApiResponse
) {
  try {
    const block = req.query.block as string;
    const blockName = block.match(/(.*)\.png/)![1];
    res.setHeader("Content-Type", "image/png");

    const imagePath = path.resolve(
      __dirname,
      `../../../../../../../blocks/${blockName}/preview.png`
    );

    console.log("path:", imagePath);

    fs.createReadStream(imagePath).pipe(res);
  } catch (error) {
    console.error(error);
    return res.status(404).end();
  }
}
