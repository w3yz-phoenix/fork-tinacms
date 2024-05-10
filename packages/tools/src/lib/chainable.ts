export class Chainable<T> {
  constructor(private value: T) {}

  apply<U>(fn: (input: T) => U): Chainable<T & U> {
    return new Chainable({
      ...this.value,
      ...fn(this.value),
    });
  }

  get() {
    return this.value;
  }
}

export function createPartial<TInput, TOutput, Passthrough>(
  fn: (input: TInput) => TOutput
) {
  return (input: TInput & Passthrough) => {
    const partialOutput = fn(input);
    return { ...input, ...partialOutput };
  };
}
