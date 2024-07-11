@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZBS_R_DMOLanguage
  as select from ZBS_DMO_LANG as Language
{
  key identification as Identification,
  source_language as SourceLanguage,
  source_text as SourceText,
  target_language as TargetLanguage,
  target_text as TargetText,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged
  
}
