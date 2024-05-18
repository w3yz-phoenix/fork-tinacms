import axios from "axios";

export function getUri(path = "") {
  return `${
    process.env.NEXT_PUBLIC_LANDING_STRAPI_URI || "http://localhost:1337"
  }${path}`;
}

export function getApiInstance(token?: any) {
  const config = {
    baseURL: process.env.NEXT_PUBLIC_LANDING_STRAPI_API_URI,
    headers: {
      Authorization: `Bearer ${
        token ?? process.env.NEXT_PUBLIC_LANDING_STRAPI_API_KEY
      }`,
    },
  };

  return axios.create(config);
}
