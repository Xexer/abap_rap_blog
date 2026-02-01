@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZBS_R_DMOTreeTeam
  as select from zbs_dmo_team as Team
  association of many to one ZBS_R_DMOTreeTeam as _TeamLeader on $projection.TeamLeader = _TeamLeader.UserId
  association of many to many ZBS_R_DMOTreeTeam as _Member on $projection.UserId = _Member.TeamLeader
{
  key user_id               as UserId,
      player_name           as PlayerName,
      player_email          as PlayerEmail,
      player_position       as PlayerPosition,
      score                 as Score,
      team                  as Team,
      team_leader           as TeamLeader,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed    as LocalLastChanged,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed          as LastChanged,
      _TeamLeader,
      _Member
}
