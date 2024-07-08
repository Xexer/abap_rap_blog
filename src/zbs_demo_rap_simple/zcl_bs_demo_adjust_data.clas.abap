CLASS zcl_bs_demo_adjust_data DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS adjust_via_request
      IMPORTING io_request TYPE REF TO if_rap_query_request
      CHANGING  ct_data    TYPE STANDARD TABLE.

    METHODS filter_data
      IMPORTING it_filter TYPE if_rap_query_filter=>tt_name_range_pairs
      CHANGING  ct_data   TYPE STANDARD TABLE.

    METHODS order_data
      IMPORTING it_sort TYPE if_rap_query_request=>tt_sort_elements
      CHANGING  ct_data TYPE STANDARD TABLE.

    METHODS page_data
      IMPORTING id_offset    TYPE int8
                id_page_size TYPE int8
      CHANGING  ct_data      TYPE STANDARD TABLE.
ENDCLASS.


CLASS zcl_bs_demo_adjust_data IMPLEMENTATION.
  METHOD adjust_via_request.
    DATA(lt_sort) = io_request->get_sort_elements( ).
    DATA(ld_offset) = io_request->get_paging( )->get_offset( ).
    DATA(ld_page_size) = io_request->get_paging( )->get_page_size( ).
    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        CLEAR lt_filter.
    ENDTRY.

    filter_data( EXPORTING it_filter = lt_filter
                 CHANGING  ct_data   = ct_data ).

    order_data( EXPORTING it_sort = lt_sort
                CHANGING  ct_data = ct_data ).

    page_data( EXPORTING id_offset    = ld_offset
                         id_page_size = ld_page_size
               CHANGING  ct_data      = ct_data ).
  ENDMETHOD.


  METHOD filter_data.
    LOOP AT it_filter INTO DATA(ls_filter).
      LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_data>).
        DATA(ld_index) = sy-tabix.
        ASSIGN COMPONENT ls_filter-name OF STRUCTURE <ls_data> TO FIELD-SYMBOL(<ld_field>).
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.

        IF <ld_field> NOT IN ls_filter-range.
          DELETE ct_data INDEX ld_index.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD order_data.
    DATA(lt_sort) = CORRESPONDING abap_sortorder_tab( it_sort MAPPING name = element_name ).
    SORT ct_data BY (lt_sort).
  ENDMETHOD.


  METHOD page_data.
    DATA lr_data TYPE REF TO data.
    DATA ld_from TYPE i.
    DATA ld_to   TYPE i.
    FIELD-SYMBOLS <lt_result> TYPE STANDARD TABLE.

    CREATE DATA lr_data LIKE ct_data.
    ASSIGN lr_data->* TO <lt_result>.

    IF id_offset IS NOT INITIAL.
      ld_from = id_offset + 1.
    ELSE.
      ld_from = 1.
    ENDIF.

    IF id_page_size IS NOT INITIAL.
      ld_to = ld_from + id_page_size - 1.
    ELSE.
      ld_to = lines( ct_data ).
    ENDIF.

    LOOP AT ct_data ASSIGNING FIELD-SYMBOL(<ls_result>) FROM ld_from TO ld_to.
      INSERT <ls_result> INTO TABLE <lt_result>.
    ENDLOOP.

    ct_data = <lt_result>.
  ENDMETHOD.
ENDCLASS.
