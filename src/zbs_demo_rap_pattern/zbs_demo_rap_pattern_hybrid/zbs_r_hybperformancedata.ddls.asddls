@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Performance Data'
define root view entity ZBS_R_HYBPerformanceData
  as select from ZBS_X_DemoSQLPerformance
  association of one to one ZBS_I_HYBPerformanceAdditional as _Additional on _Additional.Identifier = $projection.Identifier
{
  key Identifier,
      ItemDescription,
      RandomDescription,
      Amount,
      Currency,
      NewDate,
      NewTime,
      _Additional.LineComment,
      _Additional.ResponsiblePerson,
      _Additional.LocalCreatedBy,
      _Additional.LocalCreatedAt,
      _Additional.LocalLastChangedBy,
      _Additional.LocalLastChangedAt,
      _Additional.LastChangedAt
}
