@ClientHandling.type: #CLIENT_DEPENDENT
@AbapCatalog.deliveryClass: #APPLICATION_DATA
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Draft for Position'
define table entity ZBS_T_CDSPatternPosDraft
{
  key DocumentNumber   : abap.char(8);
  key PositionNumber   : abap.int2;
  key DraftUUID        : sdraft_uuid;
      ParentDraftUUID  : sdraft_uuid;
      MaterialNumber   : abap.char(5);
      @Semantics.quantity.unitOfMeasure : 'PositionUnit'
      PositionQuantity : abap.quan(10,0);
      PositionUnit     : abap.unit(3);
      @Semantics.amount.currencyCode : 'PositionCurrency'
      PositionPrice    : abap.curr(15,2);
      PositionCurrency : abap.cuky;
      include SYCH_BDL_DRAFT_ADMIN_INC.* signature only;
}
