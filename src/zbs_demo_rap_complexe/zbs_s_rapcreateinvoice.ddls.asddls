@EndUserText.label: 'Create Invoice'
define root abstract entity ZBS_S_RAPCreateInvoice
{
  key DummyKey  : abap.char(1);
      Document  : abap.char(8);
      Partner   : abap.char(10);
      _Position : composition [0..*] of ZBS_S_RAPCreatePosition;
}
