export const createFetcher =
  (endpoint: string) =>
  <TData, TVariables>(
    query: string,
    variables?: TVariables,
    headers?: RequestInit["headers"]
  ): ((requestParameters?: RequestInit) => Promise<TData>) => {
    return async () => {
      console.log("fetching:", endpoint);
      const res = await fetch(endpoint, {
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

      const json = await res.json();

      if (json.errors) {
        const { message } = json.errors[0] || {};
        throw new Error(message || "Error…");
      }

      return json.data;
    };
  };
