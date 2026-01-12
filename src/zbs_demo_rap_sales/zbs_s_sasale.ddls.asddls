define abstract entity ZBS_S_SASale
{
  PartnerNumber : ZBS_DEMO_SA_PARTNER;
  SalesDate : ZBS_DEMO_SA_DATE;
  @Semantics.amount.currencyCode: 'SalesCurrency'
  SalesVolume : ZBS_DEMO_SA_AMOUNT;
  SalesCurrency : ZBS_DEMO_SA_CURRENCY;
  @Semantics.amount.currencyCode: 'DifferenceCurrency'
  DifferenceAmount : ZBS_DEMO_SA_AMOUNT;
  DifferenceCurrency : ZBS_DEMO_SA_CURRENCY;
  @Semantics.quantity.unitOfMeasure: 'DifferenceUnit'
  DifferenceQuantity : ZBS_DEMO_SA_QUANTITY;
  DifferenceUnit : ZBS_DEMO_SA_UNIT;
  SaleComment : ZBS_DEMO_SA_COMMENT;
}
