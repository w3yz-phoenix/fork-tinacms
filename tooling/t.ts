async function complex() {
  const a = await 1;
  const b = await 2;
  return a + b;
}

const result = await complex();
console.log(result);
