CLASS zcl_bs_demo_read_odata DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      c_destination TYPE string VALUE `<destination-service-id>`.

    METHODS:
      get_client
        RETURNING VALUE(ro_result) TYPE REF TO if_web_http_client
        RAISING
                  cx_http_dest_provider_error
                  cx_web_http_client_error.
ENDCLASS.



CLASS ZCL_BS_DEMO_READ_ODATA IMPLEMENTATION.


  METHOD get_client.
    DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
      i_name       = c_destination
      i_authn_mode = if_a4c_cp_service=>service_specific
    ).

    ro_result  = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA:
      lt_business_data TYPE TABLE OF zbs_rap_companynames.

    TRY.
        DATA(lo_client_proxy) = cl_web_odata_client_factory=>create_v2_remote_proxy(
          EXPORTING
            iv_service_definition_name = 'ZBS_DEMO_RAP_ONPREM_ODATA'
            io_http_client             = get_client( )
            iv_relative_service_root   = '/sap/opu/odata/sap/ZBS_API_COMPANY_NAMES_O2' ).

        DATA(lo_request) = lo_client_proxy->create_resource_for_entity_set( 'COMPANYNAMES' )->create_request_for_read( ).
        lo_request->set_top( 50 )->set_skip( 0 ).

        DATA(lo_response) = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

        out->write( 'Data on-premise found:' ).
        out->write( lt_business_data ).

      CATCH cx_root INTO DATA(lo_error).
        out->write( lo_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
