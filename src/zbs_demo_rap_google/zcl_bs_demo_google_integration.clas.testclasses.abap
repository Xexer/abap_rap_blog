CLASS ltc_google_api DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS translate_apple  FOR TESTING.
    METHODS translate_fruits FOR TESTING.
    METHODS dont_translate   FOR TESTING.
ENDCLASS.


CLASS ltc_google_api IMPLEMENTATION.
  METHOD translate_apple.
    DATA(lo_cut) = NEW zcl_bs_demo_google_integration( ).

    DATA(ld_result) = lo_cut->translate_text( `Apfel` ).

    cl_abap_unit_assert=>assert_equals( exp = `Apple`
                                        act = ld_result ).
  ENDMETHOD.


  METHOD translate_fruits.
    DATA(lo_cut) = NEW zcl_bs_demo_google_integration( ).

    DATA(lt_result) = lo_cut->translate_texts( VALUE #( ( `Apfel` ) ( `Birne` ) ) ).

    cl_abap_unit_assert=>assert_equals( exp = VALUE string_table( ( `Apple` ) ( `Pear` ) )
                                        act = lt_result ).
  ENDMETHOD.


  METHOD dont_translate.
    DATA(lo_cut) = NEW zcl_bs_demo_google_integration( ).

    DATA(ld_result) = lo_cut->translate_text( `Apple` ).

    cl_abap_unit_assert=>assert_equals( exp = `Apple`
                                        act = ld_result ).
  ENDMETHOD.
ENDCLASS.
