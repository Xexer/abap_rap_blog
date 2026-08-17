@EndUserText.label: 'File Upload Entity'
define root abstract entity ZBS_S_SAFileUpload
{
  @Semantics.largeObject: {
    mimeType : 'MimeType',
    fileName : 'Filename'
  }
  Attachment : abap.rawstring;
  @Semantics.mimeType: true
  @UI.hidden : true
  MimeType   : abap.char(128);
  @UI.hidden : true
  Filename   : abap.char(128);
}
