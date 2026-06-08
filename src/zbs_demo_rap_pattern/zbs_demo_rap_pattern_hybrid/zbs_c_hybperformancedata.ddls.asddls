@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Performance'
@Metadata.allowExtensions: true
define root view entity ZBS_C_HYBPerformanceData
  provider contract transactional_query
  as projection on ZBS_R_HYBPerformanceData
{
  key Identifier,
      ItemDescription,
      RandomDescription,
      Amount,
      Currency,
      NewDate,
      NewTime,
      LineComment,
      ResponsiblePerson,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
