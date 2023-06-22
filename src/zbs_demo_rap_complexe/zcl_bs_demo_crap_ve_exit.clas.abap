CLASS zcl_bs_demo_crap_ve_exit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
ENDCLASS.


CLASS zcl_bs_demo_crap_ve_exit IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    LOOP AT it_requested_calc_elements INTO DATA(ld_virtual_field).
      LOOP AT ct_calculated_data ASSIGNING FIELD-SYMBOL(<ls_calculated_data>).
        DATA(ld_tabix) = sy-tabix.
        ASSIGN COMPONENT ld_virtual_field OF STRUCTURE <ls_calculated_data> TO FIELD-SYMBOL(<ld_field>).

        DATA(ls_original) = CORRESPONDING ZBS_C_RAPCInvoice( it_original_data[ ld_tabix ] ).

        IF ls_original-Partner = '1000000002'.
          <ld_field> = 999.

        ELSE.
          SELECT FROM zbs_dmo_position
            FIELDS COUNT( * )
            WHERE document = @ls_original-Document
            INTO @<ld_field>.

        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
