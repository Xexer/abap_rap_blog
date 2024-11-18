CLASS zcl_bs_demo_custom_company_qry DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    CONSTANTS c_destination TYPE string                                         VALUE `<destination-service-id>`.
    CONSTANTS c_entity      TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'COMPANYNAMES'.

    CLASS-METHODS get_proxy
      RETURNING VALUE(ro_result) TYPE REF TO /iwbep/if_cp_client_proxy.

  PRIVATE SECTION.
    TYPES tt_result TYPE STANDARD TABLE OF ZBS_I_RAPCustomEntityCNames WITH EMPTY KEY.

    METHODS read_data_by_request
      IMPORTING io_request TYPE REF TO if_rap_query_request
      EXPORTING et_result  TYPE tt_result
                ed_count   TYPE int8.
ENDCLASS.



CLASS ZCL_BS_DEMO_CUSTOM_COMPANY_QRY IMPLEMENTATION.


  METHOD get_proxy.
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
            i_name       = c_destination
            i_authn_mode = if_a4c_cp_service=>service_specific ).

        DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        ro_result = cl_web_odata_client_factory=>create_v2_remote_proxy(
            iv_service_definition_name = 'ZBS_DEMO_RAP_ONPREM_ODATA'
            io_http_client             = lo_client
            iv_relative_service_root   = '/sap/opu/odata/sap/ZBS_API_COMPANY_NAMES_O2' ).

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA lt_result TYPE STANDARD TABLE OF ZBS_R_RAPCustomCompanyNames.

    read_data_by_request( EXPORTING io_request = io_request
                          IMPORTING et_result  = DATA(lt_company_names)
                                    ed_count   = DATA(ld_count) ).

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( ld_count ).
    ENDIF.

    IF io_request->is_data_requested( ).
      lt_result = CORRESPONDING #( lt_company_names ).
      io_response->set_data( lt_result ).
    ENDIF.
  ENDMETHOD.


  METHOD read_data_by_request.
    DATA lo_root_filter_node TYPE REF TO /iwbep/if_cp_filter_node.

    TRY.
        DATA(lo_request) = get_proxy( )->create_resource_for_entity_set( c_entity )->create_request_for_read( ).

        DATA(lt_filter_condition) = io_request->get_filter( )->get_as_ranges( ).
        DATA(lt_requested_elements) = io_request->get_requested_elements( ).
        DATA(lt_sort_elements) = io_request->get_sort_elements( ).
        DATA(ld_skip) = io_request->get_paging( )->get_offset( ).
        DATA(ld_top) = io_request->get_paging( )->get_page_size( ).
        DATA(ld_is_data_requested)  = io_request->is_data_requested( ).
        DATA(ld_is_count_requested) = io_request->is_total_numb_of_rec_requested( ).

        DATA(lo_filter_factory) = lo_request->create_filter_factory( ).
        LOOP AT lt_filter_condition INTO DATA(ls_filter_condition).
          DATA(lo_filter_node) = lo_filter_factory->create_by_range( iv_property_path = ls_filter_condition-name
                                                                     it_range         = ls_filter_condition-range ).

          IF lo_root_filter_node IS INITIAL.
            lo_root_filter_node = lo_filter_node.
          ELSE.
            lo_root_filter_node = lo_root_filter_node->and( lo_filter_node ).
          ENDIF.
        ENDLOOP.

        IF lo_root_filter_node IS NOT INITIAL.
          lo_request->set_filter( lo_root_filter_node ).
        ENDIF.

        IF lt_requested_elements IS NOT INITIAL.
          lo_request->set_select_properties( CORRESPONDING #( lt_requested_elements ) ).
        ENDIF.

        IF lt_sort_elements IS NOT INITIAL.
          lo_request->set_orderby( CORRESPONDING #( lt_sort_elements MAPPING property_path = element_name ) ).
        ENDIF.

        IF ld_is_data_requested = abap_true.
          lo_request->set_skip( CONV #( ld_skip ) ).

          IF ld_top > 0.
            lo_request->set_top( CONV #( ld_top ) ).
          ENDIF.
        ELSE.
          lo_request->request_no_business_data( ).
        ENDIF.

        IF ld_is_count_requested = abap_true.
          lo_request->request_count( ).
        ENDIF.

        DATA(lo_response) = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = et_result ).
        ed_count = lo_response->get_count( ).

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
