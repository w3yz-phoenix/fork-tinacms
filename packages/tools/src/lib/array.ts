export const isPresent = <T>(v: T | null | undefined): v is T =>
  v !== undefined && v !== null;

export const getStringIfNotEmpty = (a: string | null | undefined) => {
  if (a && a.length > 0) {
    return a;
  }

  return;
};
