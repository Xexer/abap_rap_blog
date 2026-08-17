@EndUserText.label: 'Flat File Upload Dialog'
define root abstract entity ZBS_S_SAPopupFlatFile
{
  @EndUserText.label: 'Description'
  Description : abap.char(60);

  @EndUserText.label: 'Test Mode'
  TestMode    : abap_boolean;

  @EndUserText.label: 'File Name'
  _Files      : association [1] to ZBS_S_SAFileUpload on 1 = 1;
}
