export const createFetcher =
  (endpoint: string) =>
  <TData, TVariables>(
    query: string,
    variables?: TVariables,
    headers?: RequestInit["headers"]
  ): ((requestParameters?: RequestInit) => Promise<TData>) => {
    return async (requestParameters?: RequestInit) => {
      const res = await fetch(endpoint, {
        method: "POST",
        ...requestParameters,
        headers: {
          "Content-Type": "application/json",
          ...headers,
          ...requestParameters?.headers,
        },
        body: JSON.stringify({
          query,
          variables,
        }),
      });

      const json = await res.json();

      if (json.errors) {
        const { message } = json.errors[0] || {};
        throw new Error(message || "Error…");
      }

      return json.data;
    };
  };
