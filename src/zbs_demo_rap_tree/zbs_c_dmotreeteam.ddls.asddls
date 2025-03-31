@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
@OData.hierarchy.recursiveHierarchy:[{ entity.name: 'ZBS_I_DMOTreeTeamHR' }]
define root view entity ZBS_C_DMOTreeTeam
  provider contract transactional_query
  as projection on ZBS_R_DMOTreeTeam
  association of many to one ZBS_C_DMOTreeTeam as _TeamLeader on $projection.TeamLeader = _TeamLeader.UserId
{
  key UserId,
  PlayerName,
  PlayerEmail,
  PlayerPosition,
  Score,
  Team,
  TeamLeader,
  LocalCreatedBy,
  LocalLastChangedBy,
  LocalLastChanged,
  LastChanged,
  _TeamLeader
  
}
