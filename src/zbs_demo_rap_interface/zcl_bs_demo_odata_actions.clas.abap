CLASS zcl_bs_demo_odata_actions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      c_destination TYPE string VALUE `<destination-service-id>`,
      c_entity      TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'COMPANYNAMES'.

    METHODS:
      get_proxy
        RETURNING VALUE(ro_result) TYPE REF TO /iwbep/if_cp_client_proxy,

      read_data_with_filter
        IMPORTING
          io_out TYPE REF TO if_oo_adt_classrun_out
        RAISING
          /iwbep/cx_gateway,
      create_new_company
        IMPORTING
          io_out TYPE REF TO if_oo_adt_classrun_out
        RAISING
          /iwbep/cx_gateway,
      update_company_description
        IMPORTING
          io_out TYPE REF TO if_oo_adt_classrun_out
        RAISING
          /iwbep/cx_gateway,
      delete_company
        IMPORTING
          io_out TYPE REF TO if_oo_adt_classrun_out
        RAISING
          /iwbep/cx_gateway.
ENDCLASS.



CLASS zcl_bs_demo_odata_actions IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    TRY.
        read_data_with_filter( out ).
        create_new_company( out ).
        update_company_description( out ).
        delete_company( out ).

      CATCH cx_root INTO DATA(lo_error).
        out->write( lo_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_proxy.
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
          i_name       = c_destination
          i_authn_mode = if_a4c_cp_service=>service_specific
        ).

        DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        ro_result = cl_web_odata_client_factory=>create_v2_remote_proxy(
          EXPORTING
            iv_service_definition_name = 'ZBS_DEMO_RAP_ONPREM_ODATA'
            io_http_client             = lo_client
            iv_relative_service_root   = '/sap/opu/odata/sap/ZBS_API_COMPANY_NAMES_O2' ).

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.


  METHOD read_data_with_filter.
    DATA:
      lt_r_branch TYPE RANGE OF zbs_rap_companynames-Branch,
      lt_found    TYPE STANDARD TABLE OF zbs_rap_companynames.

    lt_r_branch = VALUE #( sign = 'I' option = 'EQ'
      ( low = 'Software' )
      ( low = 'Food' )
    ).

    DATA(lo_request) = get_proxy( )->create_resource_for_entity_set( c_entity )->create_request_for_read( ).

    DATA(lo_filter_factory) = lo_request->create_filter_factory( ).
    DATA(lo_filter)  = lo_filter_factory->create_by_range( iv_property_path = 'BRANCH' it_range = lt_r_branch ).
    lo_request->set_filter( lo_filter ).

    DATA(lo_response) = lo_request->execute( ).
    lo_response->get_business_data( IMPORTING et_business_data = lt_found ).

    io_out->write( `Read with filter active:` ).
    io_out->write( lt_found ).
  ENDMETHOD.


  METHOD create_new_company.
    DATA:
      ls_created TYPE zbs_rap_companynames.

    DATA(ls_new_company) = VALUE zbs_rap_companynames(
      CompanyName = 'Gazprom'
      Branch = 'Gas'
    ).

    DATA(lo_request) = get_proxy( )->create_resource_for_entity_set( c_entity )->create_request_for_create( ).
    lo_request->set_business_data( ls_new_company ).

    DATA(lo_response) = lo_request->execute( ).
    lo_response->get_business_data( IMPORTING es_business_data = ls_created ).

    io_out->write( `Created new company:` ).
    io_out->write( ls_created ).
  ENDMETHOD.


  METHOD update_company_description.
    DATA:
      ls_updated TYPE zbs_rap_companynames.

    DATA(ls_key) = VALUE zbs_rap_companynames( companyname = 'Gazprom' ).

    DATA(ls_update_company) = VALUE zbs_rap_companynames(
      companyname         = 'Gazprom'
      branch              = 'Gas'
      companydescription  = `PJSC Gazprom is a Russian majority state-owned multinational energy corporation headquartered in the Lakhta Center in Saint Petersburg.`
    ).

    DATA(lo_request) = get_proxy( )->create_resource_for_entity_set( c_entity
      )->navigate_with_key( ls_key
      )->create_request_for_update( /iwbep/if_cp_request_update=>gcs_update_semantic-put
    ).
    lo_request->set_business_data( ls_update_company ).

    DATA(lo_response) = lo_request->execute( ).
    lo_response->get_business_data( IMPORTING es_business_data = ls_updated ).

    io_out->write( `Updated company:` ).
    io_out->write( ls_updated ).
  ENDMETHOD.


  METHOD delete_company.
    DATA(ls_key) = VALUE zbs_rap_companynames( companyname = 'Gazprom' ).

    DATA(lo_request) = get_proxy( )->create_resource_for_entity_set( c_entity
      )->navigate_with_key( ls_key
      )->create_request_for_delete(
    ).

    lo_request->execute( ).

    io_out->write( `Company deleted:` ).
  ENDMETHOD.
ENDCLASS.
