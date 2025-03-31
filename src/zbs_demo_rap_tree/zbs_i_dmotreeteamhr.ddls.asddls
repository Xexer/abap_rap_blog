define hierarchy ZBS_I_DMOTreeTeamHR
  as parent child hierarchy(
    source ZBS_R_DMOTreeTeam
    child to parent association _TeamLeader
    start where
      TeamLeader is initial
    siblings order by
      PlayerName ascending
  )
{
  key UserId,
      TeamLeader
}
