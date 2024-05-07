import {
  SaleorGraphql_CountryCode,
  useAddressValidationRulesQuery,
} from "@w3yz/ecom/api";

export const getAddressValidationRules = async () => {
  const response = await useAddressValidationRulesQuery.fetcher({
    countryArea: SaleorGraphql_CountryCode.Tr,
  })({
    next: { revalidate: 60 },
  });

  const countryAreaChoices =
    response?.addressValidationRules?.countryAreaChoices?.map((choice) => ({
      label: (choice?.verbose ?? "").toLocaleUpperCase("tr-TR"),
      value: (choice?.raw ?? "").toLocaleUpperCase("tr-TR"),
    })) ?? [];

  return {
    countryAreaChoices,
  };
};
