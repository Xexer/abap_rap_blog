INTERFACE zif_bs_demo_service_prov
  PUBLIC.

  TYPES:
    count           TYPE int8,
    protocol_intern TYPE c LENGTH 2,
    delete_fields   TYPE string_table,
    read_fields     TYPE string_table.

  TYPES property TYPE STANDARD TABLE OF if_com_arrangement_factory=>ty_query_param_prop WITH EMPTY KEY.

  TYPES:
    BEGIN OF arrangement,
      comm_scenario  TYPE if_com_management=>ty_cscn_id,
      service_id     TYPE if_com_management=>ty_cscn_outb_srv_id,
      comm_system_id TYPE if_com_management=>ty_cs_id,
      property       TYPE property,
    END OF arrangement.

  TYPES: BEGIN OF configuration,
           arrangement       TYPE arrangement,
           cloud_destination TYPE string,
           consumption_model TYPE /iwbep/if_cp_runtime_types=>ty_proxy_model_id,
           service_root      TYPE string,
           client            TYPE string,
           language          TYPE sy-langu,
           protocol          TYPE protocol_intern,
         END OF configuration.

  TYPES:
    BEGIN OF unit,
      field TYPE string,
      unit  TYPE string,
    END OF unit.
  TYPES units TYPE SORTED TABLE OF unit WITH UNIQUE KEY field.

  TYPES:
    BEGIN OF setting_by_value,
      entity_name        TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name,
      is_data_requested  TYPE abap_boolean,
      is_count_requested TYPE abap_boolean,
      filter_condition   TYPE if_rap_query_filter=>tt_name_range_pairs,
      sort_order         TYPE if_rap_query_request=>tt_sort_elements,
      requested_elements TYPE if_rap_query_request=>tt_requested_elements,
      unit               TYPE units,
      top                TYPE i,
      skip               TYPE i,
    END OF setting_by_value.

  TYPES:
    BEGIN OF setting_by_request,
      entity_name      TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name,
      request          TYPE REF TO if_rap_query_request,
      delete_fields    TYPE delete_fields,
      read_fields      TYPE read_fields,
      unit             TYPE units,
      top              TYPE i,
      skip             TYPE i,
      request_no_count TYPE abap_boolean,
    END OF setting_by_request.

  TYPES:
    BEGIN OF setting_with_response,
      entity_name      TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name,
      request          TYPE REF TO if_rap_query_request,
      response         TYPE REF TO if_rap_query_response,
      delete_fields    TYPE delete_fields,
      read_fields      TYPE read_fields,
      unit             TYPE units,
      request_no_count TYPE abap_boolean,
    END OF setting_with_response.

  CONSTANTS ignore_skip_settings TYPE i VALUE -1.

  CONSTANTS: BEGIN OF protocol,
               odata_v2 TYPE protocol_intern VALUE 'V2',
               odata_v4 TYPE protocol_intern VALUE 'V4',
             END OF protocol.

  METHODS read_odata_by_values
    IMPORTING setting       TYPE setting_by_value
    CHANGING  business_data TYPE ANY TABLE
              !count        TYPE count
    RAISING   zcx_bs_demo_provider_error.

  METHODS read_odata_by_request
    IMPORTING setting       TYPE setting_by_request
    CHANGING  business_data TYPE ANY TABLE
              !count        TYPE count
    RAISING   zcx_bs_demo_provider_error.

  METHODS read_odata_with_response
    IMPORTING setting       TYPE setting_with_response
    CHANGING  business_data TYPE ANY TABLE
    RAISING   zcx_bs_demo_provider_error.
ENDINTERFACE.
