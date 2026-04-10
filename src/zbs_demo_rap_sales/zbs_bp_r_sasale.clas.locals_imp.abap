CLASS lsc_zbs_r_sasale DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS
      save_modified REDEFINITION.

    METHODS create_clog_sale
      IMPORTING old              TYPE zbs_sasale
                !new             TYPE zbs_sasale
                change_indicator TYPE if_chdo_object_tools_rel=>ty_cdchngindh
      RAISING   cx_chdo_write_error.

    METHODS create_clog_seller
      IMPORTING old              TYPE zbs_saseller
                !new             TYPE zbs_saseller
                change_indicator TYPE if_chdo_object_tools_rel=>ty_cdchngindh
      RAISING   cx_chdo_write_error.
ENDCLASS.


CLASS lsc_zbs_r_sasale IMPLEMENTATION.
  METHOD save_modified.
    TRY.
        LOOP AT create-sasale INTO DATA(new_sale).
          create_clog_sale( old              = VALUE #( )
                            new              = CORRESPONDING #( new_sale MAPPING FROM ENTITY )
                            change_indicator = 'I' ).
        ENDLOOP.

        LOOP AT create-saseller INTO DATA(new_seller).
          create_clog_seller( old              = VALUE #( )
                              new              = CORRESPONDING #( new_seller MAPPING FROM ENTITY )
                              change_indicator = 'I' ).
        ENDLOOP.

        LOOP AT update-sasale INTO DATA(update_sale).
          SELECT SINGLE FROM zbs_sasale
            FIELDS *
            WHERE uuid = @update_sale-uuid
            INTO @DATA(actual_sale).

          create_clog_sale(
              old              = actual_sale
              new              = CORRESPONDING #( BASE ( actual_sale ) update_sale MAPPING FROM ENTITY USING CONTROL )
              change_indicator = 'U' ).
        ENDLOOP.

        LOOP AT update-saseller INTO DATA(update_seller).
          SELECT SINGLE FROM zbs_saseller
            FIELDS *
            WHERE uuid = @update_seller-uuid
            INTO @DATA(actual_seller).

          create_clog_seller(
              old              = actual_seller
              new              = CORRESPONDING #( BASE ( actual_seller ) update_seller MAPPING FROM ENTITY USING CONTROL )
              change_indicator = 'U' ).
        ENDLOOP.

        LOOP AT delete-sasale INTO DATA(delete_sale).
          create_clog_sale( old              = CORRESPONDING #( delete_sale MAPPING FROM ENTITY )
                            new              = VALUE #( )
                            change_indicator = 'D' ).
        ENDLOOP.

        LOOP AT create-saseller INTO DATA(delete_seller).
          create_clog_seller( old              = CORRESPONDING #( delete_seller MAPPING FROM ENTITY )
                              new              = VALUE #( )
                              change_indicator = 'D' ).
        ENDLOOP.

      CATCH cx_chdo_write_error INTO DATA(error).
        RAISE SHORTDUMP error.
    ENDTRY.
  ENDMETHOD.


  METHOD create_clog_sale.
    DATA object_id TYPE if_chdo_object_tools_rel=>ty_cdobjectv.

    IF new IS NOT INITIAL.
      object_id = new-client && new-uuid.
    ELSE.
      object_id = old-client && old-uuid.
    ENDIF.

    zcl_zbs_co_sales_chdo=>write( objectid       = object_id
                                  utime          = cl_abap_context_info=>get_system_time( )
                                  udate          = cl_abap_context_info=>get_system_date( )
                                  username       = CONV #( cl_abap_context_info=>get_user_technical_name( ) )
                                  o_zbs_sasale   = old
                                  n_zbs_sasale   = new
                                  upd_zbs_sasale = change_indicator ).
  ENDMETHOD.


  METHOD create_clog_seller.
    DATA object_id TYPE if_chdo_object_tools_rel=>ty_cdobjectv.

    IF new IS NOT INITIAL.
      object_id = new-client && new-parent_uuid.
    ELSE.
      object_id = old-client && old-parent_uuid.
    ENDIF.

    zcl_zbs_co_sales_chdo=>write( objectid         = object_id
                                  utime            = cl_abap_context_info=>get_system_time( )
                                  udate            = cl_abap_context_info=>get_system_date( )
                                  username         = CONV #( cl_abap_context_info=>get_user_technical_name( ) )
                                  o_zbs_saseller   = old
                                  n_zbs_saseller   = new
                                  upd_zbs_saseller = change_indicator ).
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
  ENDMETHOD.


  METHOD createFixValue.
    LOOP AT keys INTO DATA(key).
      MODIFY ENTITIES OF zbs_r_sasale IN LOCAL MODE
             ENTITY SASale
             CREATE FROM VALUE #( ( %cid                        = key-%cid
                                    %is_draft                   = key-%param-%is_draft
                                    PartnerNumber               = key-%param-PartnerNumber
                                    SalesDate                   = key-%param-SalesDate
                                    DifferenceAmount            = key-%param-DifferenceAmount
                                    DifferenceCurrency          = key-%param-DifferenceCurrency
                                    %control-PartnerNumber      = if_abap_behv=>mk-on
                                    %control-SalesDate          = if_abap_behv=>mk-on
                                    %control-DifferenceAmount   = if_abap_behv=>mk-on
                                    %control-DifferenceCurrency = if_abap_behv=>mk-on ) )
             MAPPED DATA(mapped_result).

      INSERT LINES OF mapped_result-sasale INTO TABLE mapped-sasale.
    ENDLOOP.
  ENDMETHOD.


  METHOD createPercent.
    LOOP AT keys INTO DATA(key).
      MODIFY ENTITIES OF zbs_r_sasale IN LOCAL MODE
             ENTITY SASale
             CREATE FROM VALUE #( ( %cid                        = key-%cid
                                    %is_draft                   = key-%param-%is_draft
                                    PartnerNumber               = key-%param-PartnerNumber
                                    SalesDate                   = key-%param-SalesDate
                                    DifferenceQuantity          = key-%param-DifferenceQuantity
                                    DifferenceUnit              = key-%param-DifferenceUnit
                                    %control-PartnerNumber      = if_abap_behv=>mk-on
                                    %control-SalesDate          = if_abap_behv=>mk-on
                                    %control-DifferenceQuantity = if_abap_behv=>mk-on
                                    %control-DifferenceUnit     = if_abap_behv=>mk-on ) )
             MAPPED DATA(mapped_result).

      INSERT LINES OF mapped_result-sasale INTO TABLE mapped-sasale.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
