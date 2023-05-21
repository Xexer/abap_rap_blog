@EndUserText.label: 'Consumption for ZBS_R_RAPCINVOICE'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZBS_C_RAPCInvoice
  provider contract transactional_query
  as projection on ZBS_R_RAPCInvoice as Invoice
{
  key Document,
      DocDate,
      DocTime,
      Partner,
      _Position : redirected to composition child ZBS_C_RAPCPosition
}
