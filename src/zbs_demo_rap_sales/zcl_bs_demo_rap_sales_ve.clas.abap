CLASS zcl_bs_demo_rap_sales_ve DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit.
    INTERFACES if_sadl_exit_calc_element_read.
    INTERFACES if_sadl_exit_sort_transform.
ENDCLASS.


CLASS zcl_bs_demo_rap_sales_ve IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA originals TYPE STANDARD TABLE OF zbs_c_sasale WITH EMPTY KEY.

    originals = CORRESPONDING #( it_original_data ).

    LOOP AT originals REFERENCE INTO DATA(original).
      LOOP AT it_requested_calc_elements INTO DATA(element).
        CASE element.
          WHEN `SALESYEAR`.
            original->SalesYear = substring( val = original->SalesDate
                                             off = 0
                                             len = 4 ).
          WHEN `SALESMONTH`.
            original->SalesMonth = substring( val = original->SalesDate
                                              off = 4
                                              len = 2 ).
          WHEN 'ISAMOUNTHIDDEN'.
            original->isAmountHidden = xsdbool( original->DifferenceAmount IS INITIAL ).
          WHEN 'ISQUANTITYHIDDEN'.
            original->isQuantityHidden = xsdbool( original->DifferenceQuantity IS INITIAL ).
          when 'BUTTONCRITICALITY'.
          original->ButtonCriticality = 1.
        ENDCASE.
      ENDLOOP.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( originals ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    et_requested_orig_elements = VALUE #( ( `SALESDATE` ) ( `DIFFERENCEAMOUNT` ) ( `DIFFERENCEQUANTITY` ) ).
  ENDMETHOD.


  METHOD if_sadl_exit_sort_transform~map_element.
    IF iv_element = 'SALESYEAR'.
      INSERT VALUE #( name = 'SALESDATE' ) INTO TABLE et_sort_elements.
    ENDIF.

    IF iv_element = 'SALESMONTH'.
      INSERT VALUE #( name = 'SALESDATE' ) INTO TABLE et_sort_elements.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
