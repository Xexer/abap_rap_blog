CLASS zcl_bs_demo_custom_git DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS get_software_component
      IMPORTING setting       TYPE zif_bs_demo_service_prov=>setting_by_request
      EXPORTING business_data TYPE zcl_bc_ift_cloud_git_service=>tt_repositories_type
                !count        TYPE int8.

  PRIVATE SECTION.
    CONSTANTS cloud_destination     TYPE string VALUE `aet-http-ba-git`.
    CONSTANTS consumption_model_git TYPE string VALUE 'ZBC_IFT_CLOUD_GIT_SERVICE'.

    METHODS get_swc_configuration
      RETURNING VALUE(result) TYPE zif_bs_demo_service_prov=>configuration.
ENDCLASS.



CLASS ZCL_BS_DEMO_CUSTOM_GIT IMPLEMENTATION.


  METHOD get_software_component.
    DATA swc_filters TYPE RANGE OF zcl_bc_ift_cloud_git_service=>ts_repositories_type-sc_name.

    DATA(provider) = zcl_bs_demo_service_prov_fact=>create_service_provider( get_swc_configuration( ) ).

    TRY.
        DATA(local_setting) = setting.
        local_setting-top = 100.

        provider->read_odata_by_request( EXPORTING setting       = local_setting
                                         CHANGING  business_data = business_data
                                                   count         = count ).

        swc_filters = VALUE #( sign   = 'I'
                               option = 'EQ'
                               ( low = 'ZBC_ABAP2UI5' )
                               ( low = 'ZBC_ATC' )
                               ( low = 'ZBS_SWC_DEMO' )
                               ( low = 'ZBS_DMO' )
                               ( low = 'ZDEMO_TRANSPORT' ) ).

        DELETE business_data WHERE sc_name NOT IN swc_filters.

      CATCH cx_root.
        CLEAR business_data.
    ENDTRY.
  ENDMETHOD.


  METHOD get_swc_configuration.
    result = VALUE zif_bs_demo_service_prov=>configuration(
        cloud_destination = cloud_destination
        consumption_model = consumption_model_git
        service_root      = `/sap/opu/odata/sap/MANAGE_GIT_REPOSITORY`
        protocol          = zif_bs_demo_service_prov=>protocol-odata_v2 ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA business_data TYPE zcl_bc_ift_cloud_git_service=>tt_repositories_type.
    DATA count         TYPE int8.

    DATA(configuration) = get_swc_configuration( ).
    DATA(provider) = zcl_bs_demo_service_prov_fact=>create_service_provider( configuration ).

    DATA(filter) = VALUE if_rap_query_filter=>tt_name_range_pairs( ( name  = 'SC_NAME'
                                                                     range = VALUE #( sign   = 'I'
                                                                                      option = 'EQ'
                                                                                      ( low = 'ZBC_ABAP2UI5' )
                                                                                      ( low = 'ZBC_ATC' )
                                                                                      ( low = 'ZBS_SWC_DEMO' )
                                                                                      ( low = 'ZBS_DMO ' )
                                                                                      ( low = 'ZDEMO_TRANSPORT   ' ) ) ) ).

    DATA(setting) = VALUE zif_bs_demo_service_prov=>setting_by_value(
        entity_name        = zif_bc_ift_service_functions=>cs_entities-repository
        is_data_requested  = abap_true
        is_count_requested = abap_true
        filter_condition   = filter ).

    TRY.
        provider->read_odata_by_values( EXPORTING setting       = setting
                                        CHANGING  business_data = business_data
                                                  count         = count ).

        out->write( business_data ).
        out->write( count ).

      CATCH zcx_bs_demo_provider_error INTO DATA(error).
        out->write( error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
