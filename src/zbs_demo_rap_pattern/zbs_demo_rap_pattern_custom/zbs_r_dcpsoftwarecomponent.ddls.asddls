@EndUserText.label: 'Software Component'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_BS_DCP_SWC_QUERY'
@ObjectModel.semanticKey: [ 'staging', 'sc_name' ]

@UI.headerInfo: { typeName: 'Software Component',
                  typeNamePlural: 'Software Components',
                  title.value: 'sc_name',
                  description.value: 'descr' }            
define root custom entity ZBS_R_DCPSoftwareComponent

{
      @Consumption.filter: { defaultValue: 'TEST', mandatory: true, selectionType: #SINGLE }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZBS_I_CPStagingVH', element: 'Staging' } } ]
      @UI.facet: [ { id: 'idRepositoryFields',
                     label: 'Technical Details',
                     position: 10,
                     type: #IDENTIFICATION_REFERENCE,
                     targetQualifier: 'REPO' },
                   { id: 'idTeam',
                     label: 'Team Information',
                     position: 20,
                     type: #IDENTIFICATION_REFERENCE,
                     targetQualifier: 'TEAM' } ]
      @UI.identification: [ { position: 10, qualifier: 'REPO' } ]
      @UI.selectionField: [ { position: 10 } ]    
      @UI.lineItem: [{ position: 10, type: #FOR_ACTION, dataAction: 'CreateOutputMessage', label: 'Create message' }]
  key staging         : zbs_demo_dcp_staging;

      @EndUserText.label: 'SWC'
      @UI.lineItem: [ { position: 20 } ]
      @UI.selectionField: [ { position: 20 } ]
      @UI.textArrangement: #TEXT_ONLY     
      @ObjectModel.text.element: [ 'descr' ] 
  key sc_name         : abap.char(18);

      @UI.hidden: true
      descr           : abap.char(60);

      @EndUserText.label: 'Type'
      @UI.lineItem: [ { position: 40 } ]
      sc_type_descr   : abap.char(40);

      @EndUserText.label: 'Available'
      @UI.lineItem: [ { position: 50 } ]
      @UI.selectionField: [ { position: 50 } ]
      avail_on_inst   : abap_boolean;

      @EndUserText.label: 'Branch'
      @UI.identification: [ { position: 30, qualifier: 'REPO' } ]
      @UI.lineItem: [ { position: 60 } ]
      active_branch   : abap.char(40);

      @EndUserText.label: 'Info'
      @UI.identification: [ { position: 40, qualifier: 'TEAM' } ]
      @UI.multiLineText: true
      information     : abap.char(200);

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZBS_I_DCPTeamVH', element: 'Team' } } ]
      @ObjectModel.text.element: [ 'TeamDescription' ]
      @UI.identification: [ { position: 50, qualifier: 'TEAM' } ]
      @UI.lineItem: [ { position: 70 } ]
      @UI.selectionField: [ { position: 60 } ]
      @UI.textArrangement: #TEXT_ONLY
      team            : zbs_demo_dcp_team;

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZBS_I_DCPApplicationVH', element: 'Application' },
                                            additionalBinding: [ { element: 'Team', localElement: 'team', usage: #FILTER } ] } ]
      @ObjectModel.text.element: [ 'ApplDescription' ]
      @UI.identification: [ { position: 60, qualifier: 'TEAM' } ]
      @UI.textArrangement: #TEXT_ONLY
      application     : zbs_demo_dcp_appl;

      @UI.hidden: true
      TeamDescription : zbs_demo_dcp_text;

      @UI.hidden: true
      ApplDescription : zbs_demo_dcp_text;
}
