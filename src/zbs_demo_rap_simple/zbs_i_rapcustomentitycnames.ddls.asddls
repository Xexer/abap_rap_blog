@EndUserText.label: 'Custom entity for company names'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_BS_DEMO_CUST_CNAME_QUERY'
define custom entity ZBS_I_RAPCustomEntityCNames
{
  key CompanyName        : abap.char( 60 );
      Branch             : abap.char( 50 );
      CompanyDescription : abap.char( 255 );
}
