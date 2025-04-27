@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'VH for Staging'

@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZBS_I_CPStagingVH
  as select from    DDCDS_CUSTOMER_DOMAIN_VALUE(
                      p_domain_name : 'ZBS_DEMO_DCP_STAGING') as Values

    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T(
                      p_domain_name : 'ZBS_DEMO_DCP_STAGING') as Texts
      on  Texts.domain_name    = Values.domain_name
      and Texts.value_position = Values.value_position
      and Texts.language       = $session.system_language

{
  @ObjectModel.text.element: [ 'Description' ]
  @UI.textArrangement: #TEXT_LAST
  key Values.value_low as Staging,

      Texts.text       as Description
}
