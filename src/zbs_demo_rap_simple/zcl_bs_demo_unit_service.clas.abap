"! @testing ZBS_UI_SIMPLE_PARTNER_O2
CLASS zcl_bs_demo_unit_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ts_key,
        PartnerNumber TYPE ZBS_C_RAPPartner-PartnerNumber,
      END OF ts_key.

    CLASS-DATA:
      go_environment TYPE REF TO if_cds_test_environment.

    CLASS-METHODS:
      class_setup RAISING cx_static_check,
      class_teardown.

    METHODS:
      get_all_partners FOR TESTING RAISING cx_static_check,
      update_unison FOR TESTING RAISING cx_static_check,
      delete_nevada_inc FOR TESTING RAISING cx_static_check,

      create_test_client
        RETURNING VALUE(ro_result) TYPE REF TO /iwbep/if_cp_client_proxy
        RAISING
                  cx_static_check.
ENDCLASS.



CLASS zcl_bs_demo_unit_service IMPLEMENTATION.
  METHOD class_setup.
    DATA:
      lt_partner TYPE STANDARD TABLE OF zbs_dmo_partner WITH EMPTY KEY.

    go_environment = cl_cds_test_environment=>create(
        i_for_entity = 'ZBS_C_RAPPARTNER'
        i_dependency_list = VALUE #( ( name = 'ZBS_DMO_PARTNER' type ='TABLE' ) )
    ).

    lt_partner = VALUE #(
      ( partner = '3000000001' name = 'Nevada Inc' country = 'US' payment_currency = 'USD' )
      ( partner = '3000000002' name = 'REWE' street = 'Main street 10' country = 'DE' payment_currency = 'EUR' )
      ( partner = '3000000003' name = 'Unison' street = 'Side road 16' country = 'AU' payment_currency = 'AUD' )
    ).

    go_environment->insert_test_data( lt_partner ).
    go_environment->enable_double_redirection( ).
  ENDMETHOD.


  METHOD class_teardown.
    go_environment->destroy( ).
  ENDMETHOD.


  METHOD create_test_client.
    ro_result = cl_web_odata_client_factory=>create_v2_local_proxy(
        VALUE #( service_id = 'ZBS_UI_SIMPLE_PARTNER_O2' service_version = '0001' )
    ).
  ENDMETHOD.


  METHOD get_all_partners.
    DATA:
      lt_result TYPE TABLE OF ZBS_C_RAPPartner.

    DATA(lo_cut) = create_test_client( ).

    DATA(lo_request) = lo_cut->create_resource_for_entity_set( 'Partner' )->create_request_for_read( ).
    DATA(lo_response) = lo_request->execute( ).
    lo_response->get_business_data( IMPORTING et_business_data = lt_result ).

    cl_abap_unit_assert=>assert_not_initial( lt_result ).
    cl_abap_unit_assert=>assert_not_initial( lt_result[ PartnerName = 'Unison' ] ).
  ENDMETHOD.


  METHOD update_unison.
    DATA(lo_cut) = create_test_client( ).

    DATA(lo_request) = lo_cut->create_resource_for_entity_set( 'Partner'
      )->navigate_with_key( VALUE ts_key( PartnerNumber = '3000000003' )
      )->create_request_for_update( /iwbep/if_cp_request_update=>gcs_update_semantic-put ).

    lo_request->set_business_data( VALUE ZBS_C_RAPPartner( Street = 'Updated' ) ).
    lo_request->execute( ).

    SELECT SINGLE FROM zbs_dmo_partner
      FIELDS *
      WHERE partner = '3000000003'
      INTO @DATA(ls_result).

    cl_abap_unit_assert=>assert_equals( act = ls_result-street exp = 'Updated' ).
  ENDMETHOD.


  METHOD delete_nevada_inc.
    DATA(lo_cut) = create_test_client( ).

    DATA(lo_request) = lo_cut->create_resource_for_entity_set( 'Partner'
      )->navigate_with_key( VALUE ts_key( PartnerNumber = '3000000001' )
      )->create_request_for_delete( ).

    lo_request->execute( ).

    SELECT SINGLE FROM zbs_dmo_partner
      FIELDS *
      WHERE partner = '3000000001'
      INTO @DATA(ls_partner).

    cl_abap_unit_assert=>assert_subrc( exp = 4 ).
  ENDMETHOD.
ENDCLASS.
