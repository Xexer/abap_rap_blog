CLASS zcl_bs_demo_tile_endpoint DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS get_tile_endpoint
      IMPORTING !path         TYPE string
      RETURNING VALUE(result) TYPE string.

    METHODS convert_config_to_json
      IMPORTING configuration TYPE zif_bs_demo_tilec=>configuration
      RETURNING VALUE(result) TYPE string.

    METHODS get_config
      IMPORTING endpoint      TYPE string
      RETURNING VALUE(result) TYPE zif_bs_demo_tilec=>configuration.

    METHODS is_endpoint_valid
      IMPORTING endpoint      TYPE string
      RETURNING VALUE(result) TYPE abap_boolean.
ENDCLASS.


CLASS zcl_bs_demo_tile_endpoint IMPLEMENTATION.
  METHOD if_http_service_extension~handle_request.
    DATA(endpoint) = get_tile_endpoint( request->get_header_field( `~path` ) ).

    DATA(configuration) = get_config( endpoint ).
    DATA(json_payload) = convert_config_to_json( configuration ).

    response->set_content_type( `application/json` ).
    response->set_text( json_payload ).
  ENDMETHOD.


  METHOD get_tile_endpoint.
    DATA(parts) = xco_cp=>string( path )->split( `/` )->value.
    DATA(last_part) = parts[ lines( parts ) ].
    DATA(endpoint) = to_upper( last_part ).

    IF NOT is_endpoint_valid( endpoint ).
      CLEAR endpoint.
    ENDIF.

    RETURN endpoint.
  ENDMETHOD.


  METHOD convert_config_to_json.
    RETURN xco_cp_json=>data->from_abap( configuration )->apply(
        VALUE #( ( xco_cp_json=>transformation->underscore_to_camel_case ) )
    )->to_string( ).
  ENDMETHOD.


  METHOD get_config.
    DATA config_handler TYPE REF TO zif_bs_demo_tilec.

    IF endpoint IS INITIAL.
      RETURN.
    ENDIF.

    DATA(class_name) = |ZCL_BS_DEMO_TILEC_{ endpoint }|.

    TRY.
        CREATE OBJECT config_handler TYPE (class_name).
        RETURN config_handler->get_configuration( ).

      CATCH cx_root.
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD is_endpoint_valid.
    DATA(regex) = `^[A-Z0-9_]+$`.
    RETURN xco_cp=>regular_expression( iv_value  = regex
                                       io_engine = xco_cp_regular_expression=>engine->pcre( )
      )->matches( endpoint ).
  ENDMETHOD.
ENDCLASS.
