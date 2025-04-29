@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'VH for Application'

@Search.searchable: true

define view entity ZBS_I_DCPApplicationVH
  as select from zbs_dcp_appl

  association of one to one ZBS_I_DCPTeamVH as _Team on _Team.Team = $projection.Team

{
      @ObjectModel.text.element: [ 'Description' ]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 1.0
      @UI.textArrangement: #TEXT_ONLY
  key application       as Application,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZBS_I_DCPTeamVH', element: 'Team' } } ]
      @ObjectModel.text.element: [ 'TeamDescription' ]
      @UI.textArrangement: #TEXT_ONLY
      team              as Team,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      description       as Description,

      @UI.hidden: true
      _Team.Description as TeamDescription
}
