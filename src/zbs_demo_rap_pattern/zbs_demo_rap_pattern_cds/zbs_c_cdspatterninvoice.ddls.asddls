@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption Invoice'
@Metadata.allowExtensions: true
define root view entity ZBS_C_CDSPatternInvoice
  provider contract transactional_query
  as projection on ZBS_T_CDSPatternInvoice
{
  key DocumentNumber,
      DocumentDate,
      DocumentTime,
      PartnerNumber,
      _Position : redirected to composition child ZBS_C_CDSPatternPosition
}
