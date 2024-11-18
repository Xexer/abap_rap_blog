"! @testing ZBS_I_RAPPartner
CLASS zcl_bs_demo_unit_rap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
      go_environment TYPE REF TO if_cds_test_environment.

    CLASS-METHODS:
      class_setup RAISING cx_static_check,
      class_teardown.

    METHODS:
      create_new_entry FOR TESTING,
      fill_empty_streets FOR TESTING,
      clear_empty_streets FOR TESTING.
ENDCLASS.



CLASS ZCL_BS_DEMO_UNIT_RAP IMPLEMENTATION.


  METHOD class_setup.
    DATA:
      lt_partner TYPE STANDARD TABLE OF zbs_dmo_partner WITH EMPTY KEY.

    go_environment = cl_cds_test_environment=>create(
        i_for_entity = 'ZBS_I_RAPPARTNER'
        i_dependency_list = VALUE #( ( name = 'ZBS_DMO_PARTNER' type ='TABLE' ) )
    ).

    lt_partner = VALUE #(
      ( partner = '2000000001' name = 'Las Vegas Corp' country = 'US' payment_currency = 'USD' )
      ( partner = '2000000002' name = 'Gorillas' street = 'Main street 10' country = 'DE' payment_currency = 'EUR' )
      ( partner = '2000000003' name = 'Tomato Inc' street = 'EMPTY' country = 'AU' payment_currency = 'AUD' )
    ).

    go_environment->insert_test_data( lt_partner ).
    go_environment->enable_double_redirection( ).
  ENDMETHOD.


  METHOD class_teardown.
    go_environment->destroy( ).
  ENDMETHOD.


  METHOD clear_empty_streets.
    DATA:
      lt_clear_streets TYPE TABLE FOR ACTION IMPORT ZBS_I_RAPPartner\\Partner~clearAllEmptyStreets.

    INSERT INITIAL LINE INTO TABLE lt_clear_streets.

    MODIFY ENTITIES OF ZBS_I_RAPPartner
      ENTITY Partner EXECUTE clearAllEmptyStreets FROM lt_clear_streets
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    COMMIT ENTITIES
      RESPONSE OF ZBS_I_RAPPartner
        REPORTED DATA(ls_commit_reported)
        FAILED DATA(ls_commit_failed).

    SELECT FROM zbs_dmo_partner
      FIELDS partner
      WHERE street = 'EMPTY'
      INTO TABLE @DATA(lt_empty_streets).

    cl_abap_unit_assert=>assert_subrc( exp = 4 ).
  ENDMETHOD.


  METHOD create_new_entry.
    DATA:
      lt_new_partner TYPE TABLE FOR CREATE ZBS_I_RAPPartner.

    lt_new_partner = VALUE #(
      ( partnername = 'Do it Yourself'
        street = 'Waterloo Street 13'
        city = 'London'
        country = 'GB'
        paymentcurrency = 'GBP'
        %control-PartnerName = if_abap_behv=>mk-on
        %control-Street = if_abap_behv=>mk-on
        %control-City = if_abap_behv=>mk-on
        %control-Country = if_abap_behv=>mk-on
        %control-PaymentCurrency = if_abap_behv=>mk-on
      )
    ).

    MODIFY ENTITIES OF ZBS_I_RAPPartner
      ENTITY Partner CREATE FROM lt_new_partner
      MAPPED DATA(ls_mapped).

    COMMIT ENTITIES
      RESPONSE OF ZBS_I_RAPPartner
        REPORTED DATA(ls_commit_reported)
        FAILED DATA(ls_commit_failed).

    cl_abap_unit_assert=>assert_initial( ls_commit_reported-partner ).
    cl_abap_unit_assert=>assert_initial( ls_commit_failed-partner ).

    SELECT SINGLE FROM zbs_dmo_partner
      FIELDS partner, name
      WHERE name = 'Do it Yourself'
      INTO @DATA(ls_partner_found).

    cl_abap_unit_assert=>assert_subrc( ).
  ENDMETHOD.


  METHOD fill_empty_streets.
    DATA:
      lt_fill_streets TYPE TABLE FOR ACTION IMPORT ZBS_I_RAPPartner\\Partner~fillEmptyStreets.

    lt_fill_streets = VALUE #(
      ( PartnerNumber = '2000000001' )
    ).

    MODIFY ENTITIES OF ZBS_I_RAPPartner
      ENTITY Partner EXECUTE fillEmptyStreets FROM lt_fill_streets
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    COMMIT ENTITIES
      RESPONSE OF ZBS_I_RAPPartner
        REPORTED DATA(ls_commit_reported)
        FAILED DATA(ls_commit_failed).

    SELECT SINGLE FROM zbs_dmo_partner
      FIELDS partner, Street
      WHERE partner = '2000000001'
      INTO @DATA(ls_partner_found).

    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = ls_partner_found-street exp = 'EMPTY' ).
  ENDMETHOD.
ENDCLASS.
