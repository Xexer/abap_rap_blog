@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Navigation Target'
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'Partner', 'SalesDate' ]
define root view entity ZBS_C_NavigationTarget
  provider contract transactional_query
  as projection on ZBS_R_SASALE
{
  key UUID          as UniqueKey,
      PartnerNumber as Partner,
      SalesDate,
      SalesVolume,
      SalesCurrency as Currency,
      DifferenceAmount,
      DifferenceCurrency,
      DifferenceQuantity,
      DifferenceUnit,
      SaleComment,
      LoggingId,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
