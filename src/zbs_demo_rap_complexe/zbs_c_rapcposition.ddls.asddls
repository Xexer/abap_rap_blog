@EndUserText.label: 'Consumption for ZBS_I_RAPCPOSITION'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZBS_C_RAPCPosition
  as projection on ZBS_I_RAPCPosition as Position
{
  key Document,
  key PositionNumber,
      Material,
      Quantity,
      Unit,
      Price,
      Currency,
      _Invoice : redirected to parent ZBS_C_RAPCInvoice
}
