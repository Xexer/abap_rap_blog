CLASS zcl_bs_demo_tile_query DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

  PRIVATE SECTION.
    METHODS extract_key
      IMPORTING !request      TYPE REF TO if_rap_query_request
      RETURNING VALUE(result) TYPE ZBS_I_DMOCustomTile-key_field.

    METHODS get_partner
      RETURNING VALUE(result) TYPE ZBS_I_DMOCustomTile.
ENDCLASS.


CLASS zcl_bs_demo_tile_query IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA tiles TYPE STANDARD TABLE OF ZBS_I_DMOCustomTile WITH EMPTY KEY.

    io_request->get_sort_elements( ).
    io_request->get_paging( )->get_offset( ).
    io_request->get_paging( )->get_page_size( ).

    DATA(identifier) = extract_key( io_request ).

    CASE identifier.
      WHEN 'PARTNER'.
        DATA(tile) = get_partner( ).
      WHEN OTHERS.
        CLEAR tile.
    ENDCASE.

    INSERT tile INTO TABLE tiles.

    IF io_request->is_data_requested( ).
      io_response->set_data( tiles ).
    ENDIF.

    IF io_request->is_data_requested( ).
      io_response->set_total_number_of_records( 1 ).
    ENDIF.
  ENDMETHOD.


  METHOD extract_key.
    TRY.
        DATA(filters) = request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        CLEAR filters.
    ENDTRY.

    TRY.
        DATA(range) = filters[ name = `KEY_FIELD` ]-range.
        DATA(value) = range[ 1 ]-low.

      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.

    DATA(regex) = xco_cp=>regular_expression( iv_value  = `^[A-Z0-9_]+$`
                                              io_engine = xco_cp_regular_expression=>engine->pcre( ) ).

    IF regex->matches( value ).
      RETURN value.
    ENDIF.
  ENDMETHOD.


  METHOD get_partner.
    SELECT FROM ZBS_C_RAPPartner
      FIELDS COUNT( * ) AS number
      INTO @DATA(total_partner_number).

    RETURN VALUE #( key_field    = 'PARTNER'
                    icon         = 'sap-icon://accessibility'
                    info         = ''
                    infoState    = zif_bs_demo_tilec=>info_state-negative
                    numberOutput = total_partner_number
                    numberDigits = ''
                    numberFactor = 'k'
                    numberState  = ''
                    numberUnit   = 'Error'
                    stateArrow   = zif_bs_demo_tilec=>arrow_state-up
                    subtitle     = 'Custom Partner Tile'
                    title        = 'New Title' ).
  ENDMETHOD.
ENDCLASS.
