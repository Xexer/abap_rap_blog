CLASS zcl_bs_demo_unmanaged_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

  PRIVATE SECTION.
    METHODS get_data_from_request
      IMPORTING io_request       TYPE REF TO if_rap_query_request
      RETURNING VALUE(rt_result) TYPE zif_bs_demo_rap_data_handler=>tt_data
      RAISING   cx_rap_query_filter_no_range.
ENDCLASS.


CLASS zcl_bs_demo_unmanaged_query IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA lt_output TYPE STANDARD TABLE OF ZBS_C_DMOUnmanaged.

    DATA(lt_database) = get_data_from_request( io_request ).
    lt_output = CORRESPONDING #( lt_database MAPPING TableKey = gen_key Description = text CreationDate = cdate ).

    IF io_request->is_data_requested( ).
      io_response->set_data( lt_output ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lines( lt_output ) ).
    ENDIF.
  ENDMETHOD.


  METHOD get_data_from_request.
    DATA lt_r_key  TYPE zif_bs_demo_rap_data_handler=>tt_r_key.
    DATA lt_r_text TYPE zif_bs_demo_rap_data_handler=>tt_r_text.
    DATA lt_r_date TYPE zif_bs_demo_rap_data_handler=>tt_r_date.

    DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
    DATA(ld_offset) = io_request->get_paging( )->get_offset( ).
    DATA(ld_pagesize) = io_request->get_paging( )->get_page_size( ).

    LOOP AT lt_filter INTO DATA(ls_filter).
      CASE ls_filter-name.
        WHEN 'TABLEKEY'.
          lt_r_key = CORRESPONDING #( ls_filter-range ).
        WHEN 'DESCRIPTION'.
          lt_r_text = CORRESPONDING #( ls_filter-range ).
        WHEN 'CREATIONDATE'.
          lt_r_date = CORRESPONDING #( ls_filter-range ).
      ENDCASE.
    ENDLOOP.

    rt_result = zcl_bs_demo_rap_data_handler=>create_instance( )->query( it_r_key  = lt_r_key
                                                                         it_r_text = lt_r_text
                                                                         it_r_date = lt_r_date ).
  ENDMETHOD.
ENDCLASS.
