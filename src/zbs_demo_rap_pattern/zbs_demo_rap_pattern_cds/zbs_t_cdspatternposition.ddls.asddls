@ClientHandling.type: #CLIENT_DEPENDENT
@AbapCatalog.deliveryClass: #APPLICATION_DATA
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS-P: Position'
define table entity ZBS_T_CDSPatternPosition
{
  key DocumentNumber   : abap.char(8);
  key PositionNumber   : abap.int2;
      MaterialNumber   : abap.char(5);
      @Semantics.quantity.unitOfMeasure : 'PositionUnit'
      PositionQuantity : abap.quan(10,0);
      PositionUnit     : abap.unit(3);
      @Semantics.amount.currencyCode : 'PositionCurrency'
      PositionPrice    : abap.curr(15,2);
      PositionCurrency : abap.cuky;
      
      _Document : association to parent ZBS_T_CDSPatternInvoice on _Document.DocumentNumber = $projection.DocumentNumber;
}
