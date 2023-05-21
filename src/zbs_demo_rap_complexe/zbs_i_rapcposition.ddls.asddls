@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for ZBS_DMO_POSITION'
define view entity ZBS_I_RAPCPosition
  as select from zbs_dmo_position
  association     to parent ZBS_R_RAPCInvoice as _Invoice  on $projection.Document = _Invoice.Document
  association [1] to ZBS_I_RAPCMaterial       as _Material on $projection.Material = _Material.Material
{
  key document            as Document,
  key pos_number          as PositionNumber,
      material            as Material,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      quantity            as Quantity,
      _Material.StockUnit as Unit,
      price               as Price,
      currency            as Currency,
      _Invoice

}
