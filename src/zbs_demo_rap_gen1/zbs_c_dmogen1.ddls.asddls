@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZBS_R_DMOGEN1'
@ObjectModel.semanticKey: [ 'UuidKey' ]
define root view entity ZBS_C_DMOGEN1
  provider contract transactional_query
  as projection on ZBS_R_DMOGEN1
{
  key UuidKey,
  Description,
  Price,
  Currency,
  LocalLastChanged
  
}
