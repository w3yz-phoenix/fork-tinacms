export const getMoneyFormatter = (currency: string) =>
  new Intl.NumberFormat("tr-TR", {
    style: "currency",
    currency,
  });

type AmountOrMoney = number | { amount: number; currency: string };

export const formatMoney = (
  amountOrMoney: AmountOrMoney,
  currency?: string
) => {
  if (typeof amountOrMoney === "number") {
    return getMoneyFormatter(currency as string).format(amountOrMoney);
  }

  return getMoneyFormatter(amountOrMoney.currency).format(amountOrMoney.amount);
};

export const formatMoneyRange = (
  range: {
    start?: { amount: number; currency: string } | null;
    stop?: { amount: number; currency: string } | null;
  } | null
) => {
  const { start, stop } = range || {};
  const startMoney = start && formatMoney(start.amount, start.currency);
  const stopMoney = stop && formatMoney(stop.amount, stop.currency);

  if (startMoney === stopMoney) {
    return startMoney;
  }

  return `${startMoney} - ${stopMoney}`;
};
