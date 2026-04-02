@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Partner Value Help'
@Search.searchable: true
define view entity ZBS_I_SAPartnerVH
  as select from zbs_dmo_partner
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 1.0
      @ObjectModel.text.element: [ 'Name' ]
      @UI.textArrangement: #TEXT_LAST
  key partner as Partner,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      name    as Name
}
