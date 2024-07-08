@EndUserText.label: 'RAP consumption for partner'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZBS_C_RAPPartner
  provider contract transactional_query
  as projection on ZBS_I_RAPPartner
{
  key PartnerNumber,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBS_I_RAPCustomEntityCNames', element: 'CompanyName' } }]
      PartnerName,
      Street,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBS_I_RAPCityVH', element: 'City' } }]
      City,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBS_C_CountryVH', element: 'Country' } }]
      Country,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH', element: 'Currency' } }]
      PaymentCurrency,
      LastChangedAt,
      LastChangedBy,
      CreatedAt,
      CreatedBy,
      LocalLastChangedAt
}
