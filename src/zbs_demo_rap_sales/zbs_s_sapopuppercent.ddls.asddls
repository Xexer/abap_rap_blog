@EndUserText.label: 'Percent Create Action'
define abstract entity ZBS_S_SAPopupPercent
{
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBS_I_SAPartnerVH', element : 'Partner' } }]
  @EndUserText.label : 'Partner'
  PartnerNumber      : zbs_demo_sa_partner;
  @EndUserText.label : 'Sales Date'
  SalesDate          : zbs_demo_sa_date;
  @Semantics.quantity.unitOfMeasure : 'DifferenceUnit'
  @EndUserText.label : 'Quantity'
  DifferenceQuantity : zbs_demo_sa_quantity;
  @EndUserText.label : 'Unit'
  DifferenceUnit     : zbs_demo_sa_unit;
}
