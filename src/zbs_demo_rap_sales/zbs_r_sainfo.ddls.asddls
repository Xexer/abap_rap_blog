@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZBS_R_SAINFO
  as select from zbs_sainfo as SAInfo
  association to parent ZBS_R_SASALE as _SASale on $projection.ParentUUID = _SASale.UUID
{
  key parent_uuid as ParentUUID,
  key language    as Language,
      text000     as TextInformation,
      _SASale
}
