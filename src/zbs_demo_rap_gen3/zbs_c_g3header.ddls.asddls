@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@ObjectModel.semanticKey: [ 'DocumentId' ]
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.sapObjectNodeType.name: 'ZBS_G3Invoice'
define root view entity ZBS_C_G3HEADER
  provider contract TRANSACTIONAL_QUERY
  as projection on ZBS_R_G3HEADER
{
  key Uuid,
  DocumentId,
  CustomerNumber,
  Description,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt,
  _G3Position : redirected to composition child ZBS_C_G3POSITION
  
}
