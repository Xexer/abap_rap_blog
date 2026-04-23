CLASS lsc_zbs_r_sasale DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS
      save_modified REDEFINITION.

ENDCLASS.


CLASS lsc_zbs_r_sasale IMPLEMENTATION.
  METHOD save_modified.
    TRY.
        DATA(helper) = NEW zcl_bs_demo_rap_auxiliary( ).
*        helper->change_document_for_create( create ).
*        helper->change_document_for_update( update ).
*        helper->change_document_for_delete( delete ).

      CATCH cx_chdo_write_error INTO DATA(error).
        RAISE SHORTDUMP error.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_sasold DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR SASeller RESULT result.
    METHODS ReleaseItems FOR MODIFY
      IMPORTING keys FOR ACTION SASeller~ReleaseItems RESULT result.

ENDCLASS.


CLASS lhc_sasold IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD ReleaseItems.
    MODIFY ENTITIES OF zbs_r_sasale IN LOCAL MODE
           ENTITY SASeller
           UPDATE FIELDS ( Confirmed )
           WITH VALUE #( FOR key IN keys
                         ( %tky = key-%tky Confirmed = abap_true ) )
           MAPPED mapped.

    READ ENTITIES OF zbs_r_sasale IN LOCAL MODE
         ENTITY SASeller
         ALL FIELDS
         WITH VALUE #( FOR key IN keys
                       ( %tky = key-%tky ) )
         RESULT DATA(result_set).

    LOOP AT result_set INTO DATA(result_record).
      INSERT VALUE #( %tky   = result_record-%tky
                      %param = CORRESPONDING #( result_record ) ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_zbs_r_sasale DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING
      REQUEST requested_authorizations FOR SASale
      RESULT result.
    METHODS ClearDifferences FOR MODIFY
      IMPORTING keys FOR ACTION SASale~ClearDifferences.

    METHODS ConsistencyCheck FOR MODIFY
      IMPORTING keys FOR ACTION SASale~ConsistencyCheck.

    METHODS createFixValue FOR MODIFY
      IMPORTING keys FOR ACTION SASale~createFixValue.

    METHODS createPercent FOR MODIFY
      IMPORTING keys FOR ACTION SASale~createPercent.
ENDCLASS.


CLASS lhc_zbs_r_sasale IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD ClearDifferences.
  ENDMETHOD.


  METHOD ConsistencyCheck.
    DATA(consistent_flag) = NEW zcl_bs_demo_rap_auxiliary( )->is_consistent( keys ).

    IF consistent_flag = abap_true.
      INSERT new_message( id       = 'ZBS_DEMO_RAP'
                          number   = '008'
                          severity = if_abap_behv_message=>severity-success )
             INTO TABLE reported-%other.
    ELSE.
      INSERT new_message( id       = 'ZBS_DEMO_RAP'
                          number   = '009'
                          severity = if_abap_behv_message=>severity-success )
             INTO TABLE reported-%other.
    ENDIF.
  ENDMETHOD.


  METHOD createFixValue.
    LOOP AT keys INTO DATA(key).
      DATA(mapped_result) = NEW zcl_bs_demo_rap_auxiliary( )->create_sale(
          VALUE #( cid                = key-%cid
                   is_draft           = key-%param-%is_draft
                   PartnerNumber      = key-%param-PartnerNumber
                   SalesDate          = key-%param-SalesDate
                   DifferenceAmount   = key-%param-DifferenceAmount
                   DifferenceCurrency = key-%param-DifferenceCurrency ) ).

      INSERT LINES OF mapped_result-sasale INTO TABLE mapped-sasale.
    ENDLOOP.
  ENDMETHOD.


  METHOD createPercent.
    LOOP AT keys INTO DATA(key).
      DATA(mapped_result) = NEW zcl_bs_demo_rap_auxiliary( )->create_sale(
          VALUE #( cid                = key-%cid
                   is_draft           = key-%param-%is_draft
                   PartnerNumber      = key-%param-PartnerNumber
                   SalesDate          = key-%param-SalesDate
                   DifferenceQuantity = key-%param-DifferenceQuantity
                   DifferenceUnit     = key-%param-DifferenceUnit ) ).

      INSERT LINES OF mapped_result-sasale INTO TABLE mapped-sasale.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
