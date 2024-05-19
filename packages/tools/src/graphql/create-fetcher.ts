import { privateEnvironment } from "../environment";

export const createFetcher =
  (endpoint: string) =>
  <TData, TVariables>(
    query: string,
    variables?: TVariables,
    headers?: RequestInit["headers"]
  ): ((requestParameters?: RequestInit) => Promise<TData>) => {
    return async () => {
      const requestStart = performance.now();
      const response = await fetch(endpoint, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          ...headers,
        },
        body: JSON.stringify({
          query,
          variables,
        }),
      });
      const requestEnd = performance.now();
      const json = await response.json();

      if (privateEnvironment.isDevelopment) {
        console.log(`POST ${endpoint} in ${requestEnd - requestStart}ms`);
      }

      if (json.errors) {
        const { message } = json.errors[0] || {};
        throw new Error(message || "Error…");
      }

      return json.data;
    };
  };
