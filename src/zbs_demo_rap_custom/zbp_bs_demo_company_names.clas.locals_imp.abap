CLASS lcl_data_buffer DEFINITION.
  PUBLIC SECTION.
    TYPES tt_data TYPE STANDARD TABLE OF ZBS_R_RAPCustomCompanyNames WITH EMPTY KEY.

    CLASS-DATA gt_create TYPE tt_data.
    CLASS-DATA gt_update TYPE tt_data.
    CLASS-DATA gt_delete TYPE tt_data.
ENDCLASS.


CLASS lhc_CompanyNames DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR CompanyNames RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE CompanyNames.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE CompanyNames.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE CompanyNames.

    METHODS read FOR READ
      IMPORTING keys FOR READ CompanyNames RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK CompanyNames.

    METHODS read_remote
      IMPORTING id_companyname   TYPE zbs_rap_companynames-CompanyName
      RETURNING VALUE(rs_result) TYPE ZBS_R_RAPCustomCompanyNames.
ENDCLASS.


CLASS lhc_CompanyNames IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD create.
    INSERT LINES OF CORRESPONDING lcl_data_buffer=>tt_data( entities ) INTO TABLE lcl_data_buffer=>gt_create.
  ENDMETHOD.


  METHOD update.
    LOOP AT entities INTO DATA(ls_entity).
      DATA(ls_original) = read_remote( ls_entity-CompanyName ).

      IF ls_entity-%control-Branch = if_abap_behv=>mk-on.
        ls_original-Branch = ls_entity-Branch.
      ENDIF.

      IF ls_entity-%control-CompanyDescription = if_abap_behv=>mk-on.
        ls_original-CompanyDescription = ls_entity-CompanyDescription.
      ENDIF.

      INSERT ls_original INTO TABLE lcl_data_buffer=>gt_update.
    ENDLOOP.
  ENDMETHOD.


  METHOD delete.
    INSERT LINES OF CORRESPONDING lcl_data_buffer=>tt_data( keys ) INTO TABLE lcl_data_buffer=>gt_delete.
  ENDMETHOD.


  METHOD read.
  ENDMETHOD.


  METHOD lock.
  ENDMETHOD.


  METHOD read_remote.
    DATA lt_r_name TYPE RANGE OF zbs_rap_companynames-CompanyName.
    DATA lt_found  TYPE STANDARD TABLE OF zbs_rap_companynames.

    lt_r_name = VALUE #( ( sign = 'I' option = 'EQ' low = id_companyname ) ).

    DATA(lo_request) = zcl_bs_demo_custom_company_qry=>get_proxy( )->create_resource_for_entity_set(
        zcl_bs_demo_custom_company_qry=>c_entity )->create_request_for_read( ).

    DATA(lo_filter_factory) = lo_request->create_filter_factory( ).
    DATA(lo_filter) = lo_filter_factory->create_by_range( iv_property_path = 'COMPANYNAME' it_range = lt_r_name ).
    lo_request->set_filter( lo_filter ).

    DATA(lo_response) = lo_request->execute( ).
    lo_response->get_business_data( IMPORTING et_business_data = lt_found ).
    rs_result = lt_found[ 1 ].
  ENDMETHOD.
ENDCLASS.


CLASS lsc_ZBS_R_RAPCUSTOMCOMPANYNAME DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS
      finalize REDEFINITION.

    METHODS
      check_before_save REDEFINITION.

    METHODS
      save REDEFINITION.

    METHODS
      cleanup REDEFINITION.

    METHODS
      cleanup_finalize REDEFINITION.

ENDCLASS.


CLASS lsc_ZBS_R_RAPCUSTOMCOMPANYNAME IMPLEMENTATION.
  METHOD finalize.
  ENDMETHOD.


  METHOD check_before_save.
  ENDMETHOD.


  METHOD save.
    DATA ls_remote_create TYPE zbs_rap_companynames.
    DATA ls_remote_update TYPE zbs_rap_companynames.

    LOOP AT lcl_data_buffer=>gt_create INTO DATA(ls_create).
      ls_remote_create = CORRESPONDING #( ls_create ).

      DATA(lo_request_create) = zcl_bs_demo_custom_company_qry=>get_proxy( )->create_resource_for_entity_set(
          zcl_bs_demo_custom_company_qry=>c_entity )->create_request_for_create( ).
      lo_request_create->set_business_data( ls_remote_create ).
      lo_request_create->execute( ).
    ENDLOOP.

    LOOP AT lcl_data_buffer=>gt_update INTO DATA(ls_update).
      ls_remote_update = CORRESPONDING #( ls_update ).
      DATA(ls_key) = VALUE zbs_rap_companynames( companyname = ls_remote_update-CompanyName ).

      DATA(lo_request_update) = zcl_bs_demo_custom_company_qry=>get_proxy( )->create_resource_for_entity_set(
          zcl_bs_demo_custom_company_qry=>c_entity
        )->navigate_with_key( ls_key
        )->create_request_for_update( /iwbep/if_cp_request_update=>gcs_update_semantic-put ).
      lo_request_update->set_business_data( ls_remote_update ).
      lo_request_update->execute( ).
    ENDLOOP.

    LOOP AT lcl_data_buffer=>gt_delete INTO DATA(ls_delete).
      DATA(ls_key_delete) = VALUE zbs_rap_companynames( companyname = ls_delete-CompanyName ).

      DATA(lo_request_delete) = zcl_bs_demo_custom_company_qry=>get_proxy( )->create_resource_for_entity_set(
          zcl_bs_demo_custom_company_qry=>c_entity
        )->navigate_with_key( ls_key_delete
        )->create_request_for_delete( ).
      lo_request_delete->execute( ).
    ENDLOOP.

    CLEAR: lcl_data_buffer=>gt_create, lcl_data_buffer=>gt_update, lcl_data_buffer=>gt_delete.
  ENDMETHOD.


  METHOD cleanup.
  ENDMETHOD.


  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
