import { getUri } from "./api";

export function getImageUri($url: string) {
  return getUri() + $url;
}
