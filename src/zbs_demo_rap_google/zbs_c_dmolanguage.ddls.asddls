@Metadata.allowExtensions: true
@EndUserText.label: 'Language (Projection)'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
define root view entity ZBS_C_DMOLanguage
  provider contract transactional_query
  as projection on ZBS_R_DMOLanguage
{
  key Identification,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Language', element: 'LanguageISOCode' } }]
      SourceLanguage,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      SourceText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Language', element: 'LanguageISOCode' } }]
      TargetLanguage,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      TargetText,
      LocalCreatedBy,
      LocalLastChangedBy,
      LocalLastChanged,
      LastChanged

}
