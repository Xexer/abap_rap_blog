@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Country Assignment'
@Metadata.allowExtensions: true
define view entity ZBS_C_DRPCurrencyCountry
  as projection on ZBS_I_DRPCurrencyCountry
{
  key Currency,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CountryVH', element: 'Country' } }]
  key Country,
      CountryName,
      CountryRanking,
      _Currency : redirected to parent ZBS_C_DRPCurrency
}
