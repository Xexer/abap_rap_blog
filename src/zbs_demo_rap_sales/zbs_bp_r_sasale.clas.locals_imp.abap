CLASS lsc_zbs_r_sasale DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS
      save_modified REDEFINITION.

ENDCLASS.


CLASS lsc_zbs_r_sasale IMPLEMENTATION.
  METHOD save_modified.
    TRY.
        " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
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
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR SASale RESULT result.

    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR SASale RESULT result.

    METHODS AuthorizationForPartner FOR VALIDATE ON SAVE
      IMPORTING keys FOR SASale~AuthorizationForPartner.
    METHODS UploadFlatFile FOR MODIFY
      keys FOR ACTION SASale~UploadFlatFile.
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


  METHOD get_global_features.
    FINAL(can_create) = NEW zcl_bs_demo_rap_sales_auth( )->has_authorization(
        activity = zcl_bs_demo_rap_sales_auth=>activities-create ).

    IF requested_features-%create = if_abap_behv=>mk-on.
      IF can_create = abap_true.
        result-%create = if_abap_behv=>fc-o-enabled.
      ELSE.
        result-%create = if_abap_behv=>fc-o-disabled.
      ENDIF.
    ENDIF.

    IF requested_features-%action-createFixValue = if_abap_behv=>mk-on.
      IF can_create = abap_true.
        result-%action-createFixValue = if_abap_behv=>fc-o-enabled.
      ELSE.
        result-%action-createFixValue = if_abap_behv=>fc-o-disabled.
      ENDIF.
    ENDIF.

    IF requested_features-%action-createPercent = if_abap_behv=>mk-on.
      IF can_create = abap_true.
        result-%action-createPercent = if_abap_behv=>fc-o-enabled.
      ELSE.
        result-%action-createPercent = if_abap_behv=>fc-o-disabled.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_instance_features.
    FINAL(auth) = NEW zcl_bs_demo_rap_sales_auth( ).

    READ ENTITIES OF zbs_r_sasale IN LOCAL MODE
         ENTITY SASale
         FIELDS ( PartnerNumber ) WITH CORRESPONDING #( keys )
         RESULT FINAL(check_sales).

    LOOP AT check_sales INTO FINAL(check_sale).
      INSERT VALUE #( %tky = check_sale-%tky ) INTO TABLE result REFERENCE INTO DATA(result_auth).

      IF requested_features-%update = if_abap_behv=>mk-on.
        IF auth->has_authorization( activity   = auth->activities-change
                                    parnter_id = check_sale-PartnerNumber ).
          result_auth->%features-%update = if_abap_behv=>fc-o-enabled.
        ELSE.
          result_auth->%features-%update = if_abap_behv=>fc-o-disabled.
        ENDIF.
      ENDIF.

      IF requested_features-%action-Edit = if_abap_behv=>mk-on.
        IF auth->has_authorization( activity   = auth->activities-change
                                    parnter_id = check_sale-PartnerNumber ).
          result_auth->%features-%action-Edit = if_abap_behv=>fc-o-enabled.
        ELSE.
          result_auth->%features-%action-Edit = if_abap_behv=>fc-o-disabled.
        ENDIF.
      ENDIF.

      IF requested_features-%delete = if_abap_behv=>mk-on.
        IF auth->has_authorization( activity   = auth->activities-delete
                                    parnter_id = check_sale-PartnerNumber ).
          result_auth->%features-%delete = if_abap_behv=>fc-o-enabled.
        ELSE.
          result_auth->%features-%delete = if_abap_behv=>fc-o-disabled.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD AuthorizationForPartner.
    FINAL(auth) = NEW zcl_bs_demo_rap_sales_auth( ).

    READ ENTITIES OF zbs_r_sasale IN LOCAL MODE
         ENTITY SASale
         FIELDS ( PartnerNumber ) WITH CORRESPONDING #( keys )
         RESULT FINAL(check_sales).

    LOOP AT check_sales INTO FINAL(check_sale).
      IF NOT auth->has_authorization( activity   = auth->activities-change
                                      parnter_id = check_sale-PartnerNumber ).
        INSERT VALUE #( %tky = check_sale-%tky
                        %msg = new_message( id       = 'ZBS_DEMO_RAP'
                                            number   = '010'
                                            severity = if_abap_behv_message=>severity-error
                                            v1       = check_sale-PartnerNumber ) )
               INTO TABLE reported-sasale.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD UploadFlatFile.
    LOOP AT keys INTO FINAL(key).
      FINAL(file_content) = xco_cp=>xstring( key-%param-_files-Attachment )->as_string(
          xco_cp_character=>code_page->utf_8 ).

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
