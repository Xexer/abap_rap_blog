@EndUserText.label: 'Excel Popup'
define root abstract entity ZBS_S_DRPExcelPopup
{
  @EndUserText.label: 'Comment'
  EventComment : abap.char(60);
  @EndUserText.label: 'Test run'
  TestRun : abap_boolean;
}
