@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZBS_R_SASOLD
  as select from zbs_sasold as SASold
  association to parent ZBS_R_SASALE as _SASale on $projection.ParentUUID = _SASale.UUID
{
  key uuid        as UUID,
      parent_uuid as ParentUUID,
      materialid  as MaterialId,
      _SASale
}
