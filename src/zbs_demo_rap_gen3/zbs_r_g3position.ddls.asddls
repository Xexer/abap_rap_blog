@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZBS_R_G3POSITION
  as select from ZBS_G3POSITION as G3Position
  association to parent ZBS_R_G3HEADER as _G3Header on $projection.ParentUuid = _G3Header.Uuid
  composition [1..*] of ZBS_R_G3NOTE as _G3Note
{
  key uuid as Uuid,
  parent_uuid as ParentUuid,
  position_number as PositionNumber,
  position_text as PositionText,
  @Semantics.amount.currencyCode: 'Currency'
  amount as Amount,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency as Currency,
  _G3Note,
  _G3Header
  
}
