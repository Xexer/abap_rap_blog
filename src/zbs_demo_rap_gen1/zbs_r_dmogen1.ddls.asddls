@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED Simple RAP'
define root view entity ZBS_R_DMOGEN1
  as select from zbs_dmo_gen1 as Simple
{
  key uuid_key as UuidKey,
  description as Description,
  @Semantics.amount.currencyCode: 'Currency'
  price as Price,
  currency as Currency,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged
  
}
