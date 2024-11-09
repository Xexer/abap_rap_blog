@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Currency'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZBS_C_DRPCurrency
  provider contract transactional_query
  as projection on ZBS_R_DRPCurrency
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 1.0
      @Search.ranking: #HIGH
  key Currency,
      Decimals,
      CurrencyISOCode,
      AlternativeCurrencyKey,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Search.ranking: #MEDIUM
      CurrencyName,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      CurrencyShortName,
      CurrencyComment,
      Documentation,
      PictureURL,
      LastEditor,
      _User.PersonFullName as EditorName,
      _Country : redirected to composition child ZBS_C_DRPCurrencyCountry
}
