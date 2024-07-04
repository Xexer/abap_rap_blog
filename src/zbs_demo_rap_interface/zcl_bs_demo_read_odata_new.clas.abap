CLASS zcl_bs_demo_read_odata_new DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS ZCL_BS_DEMO_READ_ODATA_NEW IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA lt_business_data TYPE TABLE OF zcl_bs_demo_rap_onprem_newv2=>tys_company_names_type.

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
            comm_scenario = 'ZBS_DEMO_COMM_SCENARIO' ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        DATA(lo_client_proxy) = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
            is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                proxy_model_id      = 'ZBS_DEMO_RAP_ONPREM_NEWV2'
                                                proxy_model_version = '0001' )
            io_http_client           = lo_http_client
            iv_relative_service_root = '/sap/opu/odata/sap/ZBS_API_COMPANY_NAME_O2/' ).

        DATA(lo_request) = lo_client_proxy->create_resource_for_entity_set(
            zcl_bs_demo_rap_onprem_newv2=>gcs_entity_set-company_names )->create_request_for_read( ).

        lo_request->set_top( 50 )->set_skip( 0 ).

        DATA(lo_response) = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

        out->write( lt_business_data ).

      CATCH cx_root INTO DATA(lo_error).
        out->write( lo_error->get_text( ) ).

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
