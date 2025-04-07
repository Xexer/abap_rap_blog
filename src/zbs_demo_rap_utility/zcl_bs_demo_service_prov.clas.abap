CLASS zcl_bs_demo_service_prov DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_bs_demo_service_prov_fact.

  PUBLIC SECTION.
    INTERFACES zif_bs_demo_service_prov.

  PRIVATE SECTION.
    DATA configuration TYPE zif_bs_demo_service_prov=>configuration.
    DATA query_options TYPE /iwbep/if_cp_runtime_types=>ty_t_custom_query_option.

    METHODS constructor
      IMPORTING configuration TYPE zif_bs_demo_service_prov=>configuration.

    METHODS create_client
      RETURNING VALUE(result) TYPE REF TO /iwbep/if_cp_client_proxy
      RAISING   cx_http_dest_provider_error
                zcx_bs_demo_provider_error
                /iwbep/cx_gateway
                cx_web_http_client_error.

    METHODS get_destination
      RETURNING VALUE(result) TYPE REF TO if_http_destination
      RAISING   cx_http_dest_provider_error
                zcx_bs_demo_provider_error.

    METHODS determine_communication_system
      RETURNING VALUE(result) TYPE if_com_management=>ty_cs_id
      RAISING   zcx_bs_demo_provider_error.

    METHODS set_language_for_access
      RAISING /iwbep/cx_gateway.

    METHODS set_client_for_access
      RAISING /iwbep/cx_gateway.

    METHODS set_filter_for_request
      IMPORTING odata_request TYPE REF TO /iwbep/if_cp_request_read_list
                setting       TYPE zif_bs_demo_service_prov=>setting_by_value
      RAISING   /iwbep/cx_gateway.

    METHODS set_elements_for_request
      IMPORTING odata_request TYPE REF TO /iwbep/if_cp_request_read_list
                setting       TYPE zif_bs_demo_service_prov=>setting_by_value
      RAISING   /iwbep/cx_gateway.

    METHODS set_options_for_request
      IMPORTING odata_request TYPE REF TO /iwbep/if_cp_request_read_list
                setting       TYPE zif_bs_demo_service_prov=>setting_by_value
      RAISING   /iwbep/cx_gateway.

    METHODS set_query_options_for_request
      IMPORTING odata_request TYPE REF TO /iwbep/if_cp_request_read_list
      RAISING   /iwbep/cx_gateway.
ENDCLASS.


CLASS zcl_bs_demo_service_prov IMPLEMENTATION.
  METHOD constructor.
    me->configuration = configuration.
  ENDMETHOD.


  METHOD zif_bs_demo_service_prov~read_odata_by_request.
    TRY.
        DATA(local_setting) = CORRESPONDING zif_bs_demo_service_prov=>setting_by_value( setting ).
        local_setting-filter_condition   = setting-request->get_filter( )->get_as_ranges( ).
        local_setting-requested_elements = setting-request->get_requested_elements( ).
        local_setting-sort_order         = setting-request->get_sort_elements( ).
        local_setting-is_data_requested  = setting-request->is_data_requested( ).
        local_setting-is_count_requested = setting-request->is_total_numb_of_rec_requested( ).

        LOOP AT setting-delete_fields REFERENCE INTO DATA(field_for_deletion).
          DELETE local_setting-filter_condition WHERE name = field_for_deletion->*.
          DELETE local_setting-requested_elements WHERE table_line = field_for_deletion->*.
          DELETE local_setting-sort_order WHERE element_name = field_for_deletion->*.
        ENDLOOP.

        LOOP AT setting-read_fields REFERENCE INTO DATA(field_to_read).
          INSERT field_to_read->* INTO TABLE local_setting-requested_elements.
        ENDLOOP.

        IF setting-skip = zif_bs_demo_service_prov=>ignore_skip_settings.
          CLEAR local_setting-skip.
        ELSEIF setting-skip IS NOT INITIAL.
          local_setting-skip = setting-skip.
        ELSE.
          local_setting-skip = setting-request->get_paging( )->get_offset( ).
        ENDIF.

        IF setting-top IS NOT INITIAL.
          local_setting-top = setting-top.
        ELSE.
          local_setting-top = setting-request->get_paging( )->get_page_size( ).
        ENDIF.

        IF setting-request_no_count = abap_true.
          CLEAR local_setting-is_count_requested.
        ENDIF.

        zif_bs_demo_service_prov~read_odata_by_values( EXPORTING setting       = local_setting
                                                       CHANGING  business_data = business_data
                                                                 count         = count ).

      CATCH cx_rap_query_filter_no_range INTO DATA(error).
        RAISE EXCEPTION NEW zcx_bs_demo_provider_error( previous = error ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_bs_demo_service_prov~read_odata_by_values.
    TRY.
        DATA(odata_client) = create_client( ).
        DATA(odata_request) = odata_client->create_resource_for_entity_set( setting-entity_name )->create_request_for_read( ).

        set_filter_for_request( odata_request = odata_request
                                setting       = setting ).
        set_elements_for_request( odata_request = odata_request
                                  setting       = setting ).
        set_options_for_request( odata_request = odata_request
                                 setting       = setting ).
        set_query_options_for_request( odata_request ).

        DATA(odata_response) = odata_request->execute( ).
        IF setting-is_data_requested = abap_true.
          odata_response->get_business_data( IMPORTING et_business_data = business_data ).
        ENDIF.
        IF setting-is_count_requested = abap_true.
          count = odata_response->get_count( ).
        ENDIF.

      CATCH cx_root INTO DATA(error).
        RAISE EXCEPTION NEW zcx_bs_demo_provider_error( previous = error ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_bs_demo_service_prov~read_odata_with_response.
    DATA local_count TYPE int8.

    TRY.
        zif_bs_demo_service_prov~read_odata_by_request( EXPORTING setting       = CORRESPONDING #( setting )
                                                        CHANGING  business_data = business_data
                                                                  count         = local_count ).

      CATCH cx_rap_query_response_set_twic INTO DATA(error).
        RAISE EXCEPTION NEW zcx_bs_demo_provider_error( previous = error ).
    ENDTRY.

    IF setting-request->is_total_numb_of_rec_requested( ).
      setting-response->set_total_number_of_records( local_count ).
    ENDIF.

    IF setting-request->is_data_requested( ).
      setting-response->set_data( business_data ).
    ENDIF.
  ENDMETHOD.


  METHOD set_client_for_access.
    DATA(local_client) = configuration-client.
    IF local_client IS INITIAL.
      RETURN.
    ENDIF.

    INSERT VALUE #( name  = 'sap-client'
                    value = local_client ) INTO TABLE query_options.
  ENDMETHOD.


  METHOD set_elements_for_request.
    IF setting-requested_elements IS NOT INITIAL.
      odata_request->set_select_properties( CORRESPONDING #( setting-requested_elements ) ).
    ENDIF.

    IF setting-sort_order IS NOT INITIAL.
      odata_request->set_orderby( CORRESPONDING #( setting-sort_order MAPPING property_path = element_name ) ).
    ENDIF.
  ENDMETHOD.


  METHOD set_filter_for_request.
    DATA currency         TYPE waers_curc.
    DATA root_filter_node TYPE REF TO /iwbep/if_cp_filter_node.

    DATA(filter_factory) = odata_request->create_filter_factory( ).
    LOOP AT setting-filter_condition INTO DATA(filter_condition).
      TRY.
          currency = setting-unit[ field = filter_condition-name ]-unit.
        CATCH cx_sy_itab_line_not_found.
          CLEAR currency.
      ENDTRY.

      DATA(filter_node) = filter_factory->create_by_range( iv_property_path = filter_condition-name
                                                           it_range         = filter_condition-range
                                                           iv_currency_code = currency ).

      IF root_filter_node IS INITIAL.
        root_filter_node = filter_node.
      ELSE.
        root_filter_node = root_filter_node->and( filter_node ).
      ENDIF.
    ENDLOOP.

    IF root_filter_node IS NOT INITIAL.
      odata_request->set_filter( root_filter_node ).
    ENDIF.
  ENDMETHOD.


  METHOD set_language_for_access.
    DATA(local_language) = configuration-language.
    IF local_language IS INITIAL.
      local_language = sy-langu.
    ENDIF.

    SELECT SINGLE FROM I_Language
      FIELDS LanguageISOCode
      WHERE Language = @local_language
      INTO @DATA(iso_language).

    INSERT VALUE #( name  = 'sap-language'
                    value = iso_language ) INTO TABLE query_options.
  ENDMETHOD.


  METHOD set_options_for_request.
    IF setting-is_data_requested = abap_true.
      odata_request->set_skip( setting-skip ).

      IF setting-top > 0.
        odata_request->set_top( setting-top ).
      ENDIF.
    ENDIF.

    IF setting-is_count_requested = abap_true.
      odata_request->request_count( ).
    ENDIF.

    IF setting-is_data_requested = abap_false.
      odata_request->request_no_business_data( ).
    ENDIF.
  ENDMETHOD.


  METHOD set_query_options_for_request.
    CLEAR query_options.
    set_language_for_access( ).
    set_client_for_access( ).

    IF query_options IS NOT INITIAL.
      odata_request->set_custom_query_options( query_options ).
    ENDIF.
  ENDMETHOD.


  METHOD create_client.
    DATA(destination) = get_destination( ).
    DATA(http_client) = cl_web_http_client_manager=>create_by_http_destination( destination ).

    CASE configuration-protocol.
      WHEN zif_bs_demo_service_prov=>protocol-odata_v2.
        result = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
            is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                proxy_model_id      = configuration-consumption_model
                                                proxy_model_version = '0001' )
            io_http_client           = http_client
            iv_relative_service_root = configuration-service_root ).

      WHEN zif_bs_demo_service_prov=>protocol-odata_v4.
        result = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
            is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                proxy_model_id      = configuration-consumption_model
                                                proxy_model_version = '0001' )
            io_http_client           = http_client
            iv_relative_service_root = configuration-service_root ).

    ENDCASE.
  ENDMETHOD.


  METHOD determine_communication_system.
    IF configuration-arrangement-comm_system_id IS INITIAL AND configuration-arrangement-property IS INITIAL.
      RETURN ''.
    ENDIF.

    IF configuration-arrangement-comm_system_id IS NOT INITIAL.
      RETURN configuration-arrangement-comm_system_id.
    ENDIF.

    DATA(query) = VALUE if_com_arrangement_factory=>ty_query(
        cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = configuration-arrangement-comm_scenario ) )
        ca_property   = configuration-arrangement-property ).

    DATA(arrangement_factory) = cl_com_arrangement_factory=>create_instance( ).
    arrangement_factory->query_ca( EXPORTING is_query           = query
                                   IMPORTING et_com_arrangement = DATA(systems) ).

    IF line_exists( systems[ 1 ] ).
      RETURN systems[ 1 ]->get_comm_system_id( ).
    ELSE.
      RAISE EXCEPTION NEW zcx_bs_demo_provider_error( ).
    ENDIF.
  ENDMETHOD.


  METHOD get_destination.
    IF configuration-arrangement IS NOT INITIAL.
      result = cl_http_destination_provider=>create_by_comm_arrangement(
          comm_scenario  = configuration-arrangement-comm_scenario
          service_id     = configuration-arrangement-service_id
          comm_system_id = determine_communication_system( ) ).

    ELSEIF configuration-cloud_destination IS NOT INITIAL.
      result = cl_http_destination_provider=>create_by_cloud_destination(
          i_name       = configuration-cloud_destination
          i_authn_mode = if_a4c_cp_service=>service_specific ).
    ELSE.
      ##TODO
    ENDIF.
  ENDMETHOD.
ENDCLASS.
