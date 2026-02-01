CLASS zcl_bs_demo_custom_action_qry DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    CONSTANTS: BEGIN OF icons,
                 none  TYPE string VALUE `sap-icon://alert`,
                 one   TYPE string VALUE `sap-icon://unfavorite`,
                 two   TYPE string VALUE `sap-icon://heart-2`,
                 three TYPE string VALUE `sap-icon://cart-2`,
                 four  TYPE string VALUE `sap-icon://activate`,
               END OF icons.

    TYPES result_type TYPE STANDARD TABLE OF ZBS_R_CusActEntityTP WITH EMPTY KEY.

    METHODS get_dummy_data
      RETURNING VALUE(result) TYPE result_type.
ENDCLASS.



CLASS ZCL_BS_DEMO_CUSTOM_ACTION_QRY IMPLEMENTATION.


  METHOD get_dummy_data.
    RETURN VALUE #( ( my_key = 'TEST' description = 'First One' )
                    ( my_key = 'NOTHING' description = 'Second One' )
                    ( my_key = 'MORE' description = 'Third One' ) ).
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA result TYPE STANDARD TABLE OF ZBS_R_CusActEntityTP.
    DATA count  TYPE int8.

    result = get_dummy_data( ).

    NEW zcl_bs_demo_adjust_data( )->adjust_via_request( EXPORTING io_request = io_request
                                                        CHANGING  ct_data    = result
                                                                  cd_count   = count ).

    LOOP AT result REFERENCE INTO DATA(extend).
      SELECT SINGLE FROM zbs_dmo_cstat
        FIELDS status
        WHERE my_key = @extend->my_key
        INTO @DATA(found_status).

      IF sy-subrc <> 0.
        extend->icon = icons-none.
        CONTINUE.
      ENDIF.

      CASE found_status.
        WHEN 1.
          extend->icon = icons-one.
        WHEN 2.
          extend->icon = icons-two.
        WHEN 3.
          extend->icon = icons-three.
        WHEN OTHERS.
          extend->icon = icons-four.
      ENDCASE.
    ENDLOOP.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( count ).
    ENDIF.

    IF io_request->is_data_requested( ).
      io_response->set_data( result ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
