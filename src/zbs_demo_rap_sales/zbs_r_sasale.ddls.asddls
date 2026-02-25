@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZBS_GlobalSale'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZBS_R_SASALE
  as select from zbs_sasale as SASale
  composition of exact one to many ZBS_R_SAINFO   as _SAInfo
  composition of exact one to many ZBS_R_SASOLD   as _SASold
  composition of exact one to many ZBS_R_SASELLER as _SASeller
{
  key uuid                  as UUID,
      partnernumber         as PartnerNumber,
      salesdate             as SalesDate,
      @Semantics.amount.currencyCode: 'Salescurrency'
      salesvolume           as SalesVolume,
      salescurrency         as SalesCurrency,
      @Semantics.amount.currencyCode: 'DifferenceCurrency'
      differenceamount      as DifferenceAmount,
      differencecurrency    as DifferenceCurrency,
      @Semantics.quantity.unitOfMeasure: 'DifferenceUnit'
      differencequantity    as DifferenceQuantity,
      differenceunit        as DifferenceUnit,
      salecomment           as SaleComment,
      logging_id            as LoggingId,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      _SAInfo,
      _SASold,
      _SASeller
}
