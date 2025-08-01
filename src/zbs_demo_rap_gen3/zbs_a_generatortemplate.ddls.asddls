@EndUserText.label: 'Template for RAP Generator'
define abstract entity ZBS_A_GeneratorTemplate
{
  @EndUserText.label: 'Position'
  PositionNumber : abap.int4;
  PositionText   : abap.char( 200 );
  @Semantics.amount.currencyCode: 'Currency'
  Amount         : abap.curr( 15, 2 );
  @Semantics.currencyCode: true
  Currency       : abap.cuky( 5 );
}
