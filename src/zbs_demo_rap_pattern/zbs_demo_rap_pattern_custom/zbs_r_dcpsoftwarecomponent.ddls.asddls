@EndUserText.label: 'Software Component'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_BS_DCP_SWC_QUERY'

@UI.headerInfo: { typeName: 'Software Component',
                  typeNamePlural: 'Software Components',
                  title.value: 'sc_name',
                  description.value: 'descr' }
define custom entity ZBS_R_DCPSoftwareComponent

{
      @EndUserText.label: 'SWC'
      @UI.facet: [ { id: 'idRepositoryFields',
                     label: 'Technical Details',
                     position: 10,
                     type: #IDENTIFICATION_REFERENCE,
                     targetQualifier: 'REPO' } ]
      @UI.lineItem: [ { position: 20 } ]
      @UI.selectionField: [ { position: 20 } ]
  key sc_name       : abap.char(18);

      @EndUserText.label: 'Description'
      @UI.identification: [ { position: 20, qualifier: 'REPO' } ]
      @UI.lineItem: [ { position: 30 } ]
      descr         : abap.char(60);

      @EndUserText.label: 'Type'
      @UI.lineItem: [ { position: 40 } ]
      sc_type_descr : abap.char(40);

      @EndUserText.label: 'Available'
      @UI.lineItem: [ { position: 50 } ]
      @UI.selectionField: [ { position: 50 } ]      
      avail_on_inst : abap_boolean;

      @EndUserText.label: 'Branch'
      @UI.identification: [ { position: 30, qualifier: 'REPO' } ]
      @UI.lineItem: [ { position: 60 } ]
      active_branch : abap.char(40);
}
