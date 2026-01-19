@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZBS_R_SASOLD
  as select from zbs_sasold as SASold
  association              to parent ZBS_R_SASALE    as _SASale   on $projection.ParentUUID = _SASale.UUID
  association of exact one to one ZBS_I_SAMaterialVH as _Material on _Material.MaterialId = $projection.MaterialId
{
  key uuid        as UUID,
      parent_uuid as ParentUUID,
      materialid  as MaterialId,
      _SASale,
      _Material
}
