@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for ZBS_DMO_MATERIAL'
define view entity ZBS_I_RAPCMaterial
  as select from zbs_dmo_material
{
  key material       as Material,
      name           as MaterialName,
      description    as Description,
      stock          as Stock,
      stock_unit     as StockUnit,
      price_per_unit as PricePerUnit,
      currency       as Currency
}
