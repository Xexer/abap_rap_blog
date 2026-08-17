@EndUserText.label: 'Fix Value Create Action'
define abstract entity ZBS_S_SAPopupFixValue
{
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBS_I_SAPartnerVH', element : 'Partner' } }]
  @EndUserText.label : 'Partner'
  PartnerNumber      : zbs_demo_sa_partner;
  @EndUserText.label : 'Sales Date'
  SalesDate          : zbs_demo_sa_date;
  @Semantics.amount.currencyCode: 'DifferenceCurrency'
  @EndUserText.label : 'Amount'
  DifferenceAmount   : zbs_demo_sa_amount;
  @EndUserText.label : 'Currency'
  DifferenceCurrency : zbs_demo_sa_currency;
}
