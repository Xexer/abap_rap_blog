@EndUserText.label: 'Custom Entity with Unmanaged'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_BS_DEMO_CUSTOM_COMPANY_QRY'
@UI: {
  headerInfo: {
    typeName: 'Company name',
    typeNamePlural: 'Company names',
    title: { value: 'CompanyName' }
  }
}
define root custom entity ZBS_R_RAPCustomCompanyNames
{
      @UI.facet          : [
        {
          id             : 'FacetDetailPage',
          label          : 'General',
          type           : #IDENTIFICATION_REFERENCE,
          targetQualifier: 'DETAIL'
        }
      ]

      @UI                : {
        lineItem         : [{ position: 10 }, { type: #FOR_ACTION, dataAction: 'doSomethingWithUpdate', label: 'Custom Action' }],
        selectionField   : [ { position: 10 } ],
        identification   : [{ position: 10, qualifier: 'DETAIL' }]
      }
      @EndUserText.label: 'Company name'
  key CompanyName        : abap.char( 60 );
      @UI                : {
        lineItem         : [{ position: 20 }],
        identification   : [{ position: 20, qualifier: 'DETAIL' }]
      }
      @EndUserText.label: 'Branch'
      Branch             : abap.char( 50 );
      @UI                : {
        identification   : [{ position: 30, qualifier: 'DETAIL' }]
      }
      @EndUserText.label: 'Description'
      @UI.multiLineText: true
      CompanyDescription : abap.char( 255 );

}
