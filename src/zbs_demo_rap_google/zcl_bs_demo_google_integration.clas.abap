CLASS zcl_bs_demo_google_integration DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    "! Translate a single text
    "! @parameter id_text            | Text to be translated
    "! @parameter id_target_language | Target language
    "! @parameter rd_result          | Translated text
    METHODS translate_text
      IMPORTING id_text            TYPE string
                id_target_language TYPE string DEFAULT `en`
      RETURNING VALUE(rd_result)   TYPE string.

    "! Translates a table of texts into the target language
    "! @parameter it_text            | Table of texts
    "! @parameter id_target_language | Target language
    "! @parameter rt_result          | Table of translated texts
    METHODS translate_texts
      IMPORTING it_text            TYPE string_table
                id_target_language TYPE string DEFAULT `en`
      RETURNING VALUE(rt_result)   TYPE string_table.

  PRIVATE SECTION.
    CONSTANTS c_api_endpoint TYPE string VALUE 'https://translation.googleapis.com/language/translate/v2'.
    CONSTANTS c_api_key      TYPE string VALUE ''.

    TYPES: BEGIN OF ts_google_request,
             q      TYPE string_table,
             target TYPE string,
           END OF ts_google_request.

    TYPES: BEGIN OF ts_translation,
             translatedtext         TYPE string,
             detectedsourcelanguage TYPE string,
           END OF ts_translation.
    TYPES tt_translation TYPE STANDARD TABLE OF ts_translation WITH EMPTY KEY.

    TYPES: BEGIN OF ts_data,
             translations TYPE tt_translation,
           END OF ts_data.

    TYPES: BEGIN OF ts_google_result,
             data TYPE ts_data,
           END OF ts_google_result.

    METHODS map_result
      IMPORTING io_response      TYPE REF TO if_web_http_response
      RETURNING VALUE(rt_result) TYPE string_table
      RAISING   cx_web_message_error.

    METHODS create_payload
      IMPORTING it_text            TYPE string_table
                id_target_language TYPE string
      RETURNING VALUE(rd_result)   TYPE string.

    METHODS create_url
      RETURNING VALUE(rd_url) TYPE string.
ENDCLASS.



CLASS ZCL_BS_DEMO_GOOGLE_INTEGRATION IMPLEMENTATION.


  METHOD create_payload.
    DATA(ls_google_request) = VALUE ts_google_request( q      = it_text
                                                       target = id_target_language ).

    rd_result = /ui2/cl_json=>serialize( data          = ls_google_request
                                         name_mappings = VALUE #( ( abap = 'Q' json = 'q' )
                                                                  ( abap = 'TARGET' json = 'target' ) ) ).
  ENDMETHOD.


  METHOD create_url.
    rd_url = |{ c_api_endpoint }?key={ c_api_key }|.
  ENDMETHOD.


  METHOD map_result.
    DATA ls_google_result TYPE ts_google_result.

    IF io_response->get_status( )-code = 200.
      /ui2/cl_json=>deserialize( EXPORTING json = io_response->get_text( )
                                 CHANGING  data = ls_google_result ).
    ENDIF.

    LOOP AT ls_google_result-data-translations INTO DATA(ls_translated).
      INSERT ls_translated-TranslatedText INTO TABLE rt_result.
    ENDLOOP.
  ENDMETHOD.


  METHOD translate_text.
    DATA(lt_result) = translate_texts( it_text            = VALUE #( ( id_text ) )
                                       id_target_language = id_target_language ).

    IF line_exists( lt_result[ 1 ] ).
      rd_result = lt_result[ 1 ].
    ENDIF.
  ENDMETHOD.


  METHOD translate_texts.
    DATA(ld_url) = create_url( ).
    DATA(ld_payload) = create_payload( it_text            = it_text
                                       id_target_language = id_target_language ).

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( ld_url ).
        DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        DATA(lo_request) = lo_client->get_http_request( ).
        lo_request->set_content_type( 'application/json; charset=utf-8' ).
        lo_request->set_text( ld_payload ).
        DATA(lo_response) = lo_client->execute( i_method = if_web_http_client=>post ).

        rt_result = map_result( lo_response ).

      CATCH cx_root.
        CLEAR rt_result.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
