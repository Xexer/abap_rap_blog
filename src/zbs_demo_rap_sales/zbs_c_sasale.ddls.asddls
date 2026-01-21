@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Sales'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZBS_GlobalSale'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZBS_C_SASALE
  provider contract transactional_query
  as projection on ZBS_R_SASALE
  association of exact one to one ZBS_R_SASALE as _BaseEntity on $projection.UUID = _BaseEntity.UUID
{
  key UUID,
      PartnerNumber,
      SalesDate,
      @Semantics: {
        amount.currencyCode: 'Salescurrency'
      }
      SalesVolume,
      SalesCurrency,
      @Semantics: {
        amount.currencyCode: 'Differencecurrency'
      }
      DifferenceAmount,
      DifferenceCurrency,
      @Semantics: {
        quantity.unitOfMeasure: 'Differenceunit'
      }
      DifferenceQuantity,
      DifferenceUnit,
      SaleComment,
      
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BS_DEMO_RAP_SALES_VE'
      @ObjectModel.sort.transformedBy: 'ABAP:ZCL_BS_DEMO_RAP_SALES_VE'
      virtual SalesYear : abap.char(4),
      
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BS_DEMO_RAP_SALES_VE'
      @ObjectModel.sort.transformedBy: 'ABAP:ZCL_BS_DEMO_RAP_SALES_VE'
      virtual SalesMonth : abap.char(2),
      
      @Semantics: {
        user.createdBy: true
      }
      LocalCreatedBy,
      @Semantics: {
        systemDateTime.createdAt: true
      }
      LocalCreatedAt,
      @Semantics: {
        user.localInstanceLastChangedBy: true
      }
      LocalLastChangedBy,
      @Semantics: {
        systemDateTime.localInstanceLastChangedAt: true
      }
      LocalLastChangedAt,
      @Semantics: {
        systemDateTime.lastChangedAt: true
      }
      LastChangedAt,
      _SAInfo   : redirected to composition child ZBS_C_SAINFO,
      _SASold   : redirected to composition child ZBS_C_SASOLD,
      _SASeller : redirected to composition child ZBS_C_SASELLER,
      _BaseEntity
}
