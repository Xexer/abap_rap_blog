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
  key staging          : zbs_demo_dcp_staging;

      @EndUserText.label: 'SWC'
      @UI.lineItem: [ { position: 20 } ]
      @UI.selectionField: [ { position: 20 } ]
  key sc_name          : abap.char(18);

      @EndUserText.label: 'Description'
      @UI.identification: [ { position: 20, qualifier: 'REPO' } ]
      @UI.lineItem: [ { position: 30 } ]
      descr            : abap.char(60);

      @EndUserText.label: 'Type'
      @UI.lineItem: [ { position: 40 } ]
      sc_type_descr    : abap.char(40);

      @EndUserText.label: 'Available'
      @UI.lineItem: [ { position: 50 } ]
      @UI.selectionField: [ { position: 50 } ]
      avail_on_inst    : abap_boolean;

      @EndUserText.label: 'Branch'
      @UI.identification: [ { position: 30, qualifier: 'REPO' } ]
      @UI.lineItem: [ { position: 60 } ]
      active_branch    : abap.char(40);

      @EndUserText.label: 'Info'
      @UI.identification: [ { position: 40, qualifier: 'TEAM' } ]
      @UI.multiLineText: true
      information      : abap.char(200);

      @UI.identification: [ { position: 50, qualifier: 'TEAM' } ]
      @UI.lineItem: [ { position: 70 } ]
      @UI.selectionField: [ { position: 60 } ]
      team             : zbs_demo_dcp_team;

      @UI.identification: [ { position: 60, qualifier: 'TEAM' } ]
      application      : zbs_demo_dcp_appl;
}
