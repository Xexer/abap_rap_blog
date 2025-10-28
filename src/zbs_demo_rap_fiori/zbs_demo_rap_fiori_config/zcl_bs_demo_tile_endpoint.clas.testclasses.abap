CLASS ltc_regex DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_bs_demo_tile_endpoint.

    METHODS setup.

    METHODS only_letters            FOR TESTING RAISING cx_static_check.
    METHODS letters_and_numbers     FOR TESTING RAISING cx_static_check.
    METHODS letters_with_underscore FOR TESTING RAISING cx_static_check.
    METHODS with_dash               FOR TESTING RAISING cx_static_check.
    METHODS small_letters           FOR TESTING RAISING cx_static_check.
    METHODS with_slash              FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_bs_demo_tile_endpoint DEFINITION LOCAL FRIENDS ltc_regex.

CLASS ltc_regex IMPLEMENTATION.
  METHOD setup.
    cut = NEW zcl_bs_demo_tile_endpoint( ).
  ENDMETHOD.


  METHOD only_letters.
    DATA(result) = cut->is_endpoint_valid( `PARTNERAPP` ).

    cl_abap_unit_assert=>assert_true( result ).
  ENDMETHOD.


  METHOD letters_and_numbers.
    DATA(result) = cut->is_endpoint_valid( `PARTNER123` ).

    cl_abap_unit_assert=>assert_true( result ).
  ENDMETHOD.


  METHOD letters_with_underscore.
    DATA(result) = cut->is_endpoint_valid( `PARTNER_APP` ).

    cl_abap_unit_assert=>assert_true( result ).
  ENDMETHOD.


  METHOD with_dash.
    DATA(result) = cut->is_endpoint_valid( `PARTNER-APP` ).

    cl_abap_unit_assert=>assert_false( result ).
  ENDMETHOD.


  METHOD small_letters.
    DATA(result) = cut->is_endpoint_valid( `partnerApp` ).

    cl_abap_unit_assert=>assert_false( result ).
  ENDMETHOD.


  METHOD with_slash.
    DATA(result) = cut->is_endpoint_valid( `partner/App` ).

    cl_abap_unit_assert=>assert_false( result ).
  ENDMETHOD.
ENDCLASS.
