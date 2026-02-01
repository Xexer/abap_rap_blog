@EndUserText.label: 'Custom Entity with Action'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_BS_DEMO_CUSTOM_ACTION_QRY'
define root custom entity ZBS_R_CusActEntityTP
{
      @UI.facet   : [{
        position  : 10,
        label     : 'General',
        type      : #IDENTIFICATION_REFERENCE
      }]

      @UI.lineItem: [{ position: 10 }, 
        { type: #FOR_ACTION, dataAction: 'myCustomAction', label: 'Custom Action', invocationGrouping: #CHANGE_SET },
        { type: #FOR_ACTION, dataAction: 'resetAllIcons', label: 'Reset', invocationGrouping: #CHANGE_SET } ]
      @UI.selectionField: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
      @EndUserText.label: 'Identifier'
  key my_key      : abap.char(15);
  
      @UI.lineItem: [{ position: 20, iconUrl: 'icon' }]
      @UI.identification: [{ position: 20 }]
      @EndUserText.label: 'Description'
      description : abap.char(60);

      @UI.lineItem: [{ position: 30 }]
      @EndUserText.label: 'Icon'
      @Semantics.imageUrl: true
      icon        : abap.sstring(250);
      
}
