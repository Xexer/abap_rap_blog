@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Additional data'
define view entity ZBS_I_HYBPerformanceAdditional
  as select from zbs_hyb_perf_add
{
  key identifier            as Identifier,
      line_comment          as LineComment,
      responsible           as ResponsiblePerson,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt
}
