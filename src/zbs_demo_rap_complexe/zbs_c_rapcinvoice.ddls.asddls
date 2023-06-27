@EndUserText.label: 'Consumption for ZBS_R_RAPCINVOICE'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZBS_C_RAPCInvoice
  provider contract transactional_query
  as projection on ZBS_R_RAPCInvoice as Invoice
{
          @Search.defaultSearchElement: true
          @Search.fuzzinessThreshold: 1.0
  key     Document,
          DocDate,
          DocTime,
          @Search.defaultSearchElement: true
          @Search.fuzzinessThreshold: 0.8
          Partner,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BS_DEMO_CRAP_VE_EXIT'
  virtual NumberOfPositions : abap.int4,
          _Position : redirected to composition child ZBS_C_RAPCPosition
}
