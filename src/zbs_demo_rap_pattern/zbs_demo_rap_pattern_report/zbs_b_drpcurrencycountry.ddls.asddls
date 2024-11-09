@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Country Assignment'
define view entity ZBS_B_DRPCurrencyCountry
  as select from zbs_drp_country
{
  key currency as Currency,
  key country  as Country,
      ranking  as CountryRanking
}
