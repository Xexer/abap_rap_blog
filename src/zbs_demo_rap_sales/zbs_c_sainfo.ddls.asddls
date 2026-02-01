@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Generated'
}
@AccessControl.authorizationCheck: #MANDATORY
define view entity ZBS_C_SAINFO
  as projection on ZBS_R_SAINFO
  association of exact one to one ZBS_R_SAINFO as _BaseEntity on $projection.ParentUUID = _BaseEntity.ParentUUID
{
  key ParentUUID,
  key Language,
      TextInformation,
      _SASale : redirected to parent ZBS_C_SASALE,
      _BaseEntity
}
