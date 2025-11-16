@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption Position'
@Metadata.allowExtensions: true
define view entity ZBS_C_CDSPatternPosition
  as projection on ZBS_T_CDSPatternPosition
{
  key DocumentNumber,
  key PositionNumber,
      MaterialNumber,
      PositionQuantity,
      PositionUnit,
      PositionPrice,
      PositionCurrency,
      _Document : redirected to parent ZBS_C_CDSPatternInvoice
}
