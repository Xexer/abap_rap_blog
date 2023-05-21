@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for ZBS_DMO_INVOICE'
define root view entity ZBS_R_RAPCInvoice
  as select from zbs_dmo_invoice
  composition [0..*] of ZBS_I_RAPCPosition as _Position
{
  key document as Document,
      doc_date as DocDate,
      doc_time as DocTime,
      partner  as Partner,
      _Position
}
