@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define view entity ZBS_C_G3NOTE
  as projection on ZBS_R_G3NOTE
{
  key Uuid,
  ParentUuid,
  RootUuid,
  AdditionalNote,
  _G3Position : redirected to parent ZBS_C_G3POSITION,
  _G3Header : redirected to ZBS_C_G3HEADER
  
}
