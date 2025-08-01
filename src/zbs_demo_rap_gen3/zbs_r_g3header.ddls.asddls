@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@ObjectModel.semanticKey: [ 'DocumentId' ]
@ObjectModel.sapObjectNodeType.name: 'ZBS_G3Invoice'
define root view entity ZBS_R_G3HEADER
  as select from ZBS_G3HEADER as G3Header
  composition [1..*] of ZBS_R_G3POSITION as _G3Position
{
  key uuid as Uuid,
  document_id as DocumentId,
  customer_number as CustomerNumber,
  description as Description,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  _G3Position
  
}
