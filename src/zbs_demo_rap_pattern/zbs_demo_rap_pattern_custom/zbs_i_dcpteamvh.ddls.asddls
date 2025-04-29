@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'VH for Team'

@Search.searchable: true

define view entity ZBS_I_DCPTeamVH
  as select from zbs_dcp_team

{
      @ObjectModel.text.element: [ 'Description' ]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 1.0
      @UI.textArrangement: #TEXT_ONLY
  key team        as Team,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      description as Description
}
