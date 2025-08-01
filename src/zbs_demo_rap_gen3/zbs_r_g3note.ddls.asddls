@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZBS_R_G3NOTE
  as select from ZBS_G3NOTE as G3Note
  association to parent ZBS_R_G3POSITION as _G3Position on $projection.ParentUuid = _G3Position.Uuid
  association [1..1] to ZBS_R_G3HEADER as _G3Header on $projection.RootUuid = _G3Header.Uuid
{
  key uuid as Uuid,
  parent_uuid as ParentUuid,
  root_uuid as RootUuid,
  additional_note as AdditionalNote,
  _G3Position,
  _G3Header
  
}
