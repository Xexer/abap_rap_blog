CLASS zcl_bs_demo_rap_auxiliary DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC
  FOR BEHAVIOR OF zbs_r_sasale.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF text,
        Language        TYPE zbs_r_sainfo-Language,
        TextInformation TYPE zbs_r_sainfo-TextInformation,
      END OF text.
    TYPES texts TYPE STANDARD TABLE OF text WITH EMPTY KEY.

    TYPES: BEGIN OF sale_configuration,
             cid                TYPE abp_behv_cid,
             is_draft           TYPE abp_behv_flag,
             PartnerNumber      TYPE zbs_r_sasale-PartnerNumber,
             SalesDate          TYPE zbs_r_sasale-SalesDate,
             DifferenceAmount   TYPE zbs_r_sasale-DifferenceAmount,
             DifferenceCurrency TYPE zbs_r_sasale-DifferenceCurrency,
             DifferenceQuantity TYPE zbs_r_sasale-DifferenceQuantity,
             DifferenceUnit     TYPE zbs_r_sasale-DifferenceUnit,
           END OF sale_configuration.

    TYPES mapped_sales       TYPE RESPONSE FOR MAPPED EARLY zbs_r_sasale.

    TYPES save_change        TYPE REQUEST FOR CHANGE zbs_r_sasale.
    TYPES save_delete        TYPE REQUEST FOR DELETE zbs_r_sasale.
    TYPES action_keys        TYPE TABLE FOR ACTION IMPORT zbs_r_sasale\\sasale~consistencycheck.
    TYPES selected_sales     TYPE TABLE FOR READ RESULT zbs_r_sasale\\sasale.
    TYPES selected_sellers   TYPE TABLE FOR READ RESULT zbs_r_sasale\\sasale\_saseller.
    TYPES selected_materials TYPE TABLE FOR READ RESULT zbs_r_sasale\\sasale\_sasold.
    TYPES selected_infos     TYPE TABLE FOR READ RESULT zbs_r_sasale\\sasale\_sainfo.

    METHODS get_supported_languages
      RETURNING VALUE(result) TYPE texts.

    METHODS create_sale
      IMPORTING configuration TYPE sale_configuration
      RETURNING VALUE(result) TYPE mapped_sales.

    METHODS change_document_for_create
      IMPORTING !create TYPE save_change
      RAISING   cx_chdo_write_error.

    METHODS change_document_for_update
      IMPORTING !update TYPE save_change
      RAISING   cx_chdo_write_error.

    METHODS change_document_for_delete
      IMPORTING !delete TYPE save_delete
      RAISING   cx_chdo_write_error.

    METHODS is_consistent
      IMPORTING !keys         TYPE action_keys
      RETURNING VALUE(result) TYPE abap_boolean.

  PRIVATE SECTION.
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

    METHODS check_general
      IMPORTING selected_sales     TYPE selected_sales
                selected_materials TYPE selected_materials
                selected_infos     TYPE selected_infos
                logger             TYPE REF TO zif_aml_log.

    METHODS check_sellers
      IMPORTING selected_sellers TYPE selected_sellers
                logger           TYPE REF TO zif_aml_log.
ENDCLASS.


CLASS zcl_bs_demo_rap_auxiliary IMPLEMENTATION.
  METHOD get_supported_languages.
    RETURN VALUE #( ( language = 'D' )
                    ( language = 'E' )
                    ( language = 'F' )
                    ( language = 'I' ) ).
  ENDMETHOD.


  METHOD create_sale.
    MODIFY ENTITIES OF zbs_r_sasale IN LOCAL MODE
           ENTITY SASale
           CREATE FROM VALUE #( ( %cid                        = configuration-cid
                                  %is_draft                   = configuration-is_draft
                                  PartnerNumber               = configuration-PartnerNumber
                                  SalesDate                   = configuration-SalesDate
                                  DifferenceAmount            = configuration-DifferenceAmount
                                  DifferenceCurrency          = configuration-DifferenceCurrency
                                  DifferenceQuantity          = configuration-DifferenceQuantity
                                  DifferenceUnit              = configuration-DifferenceUnit
                                  %control-PartnerNumber      = if_abap_behv=>mk-on
                                  %control-SalesDate          = if_abap_behv=>mk-on
                                  %control-DifferenceAmount   = if_abap_behv=>mk-on
                                  %control-DifferenceCurrency = if_abap_behv=>mk-on
                                  %control-DifferenceQuantity = if_abap_behv=>mk-on
                                  %control-DifferenceUnit     = if_abap_behv=>mk-on ) )
           MAPPED result.
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


  METHOD change_document_for_create.
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
  ENDMETHOD.


  METHOD change_document_for_update.
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
  ENDMETHOD.


  METHOD change_document_for_delete.
    LOOP AT delete-sasale INTO DATA(delete_sale).
      create_clog_sale( old              = CORRESPONDING #( delete_sale MAPPING FROM ENTITY )
                        new              = VALUE #( )
                        change_indicator = 'D' ).
    ENDLOOP.

    LOOP AT delete-saseller INTO DATA(delete_seller).
      create_clog_seller( old              = CORRESPONDING #( delete_seller MAPPING FROM ENTITY )
                          new              = VALUE #( )
                          change_indicator = 'D' ).
    ENDLOOP.
  ENDMETHOD.


  METHOD is_consistent.
    DATA(logger) = zcl_aml_log_factory=>create( VALUE #( object                = 'Z_AML_LOG'
                                                         subobject             = 'TEST'
                                                         default_message_class = 'ZBS_DEMO_RAP'
                                                         use_2nd_db_connection = abap_true ) ).

    READ ENTITIES OF zbs_r_sasale IN LOCAL MODE
         ENTITY SASale
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(selected_sales)

         ENTITY SASale BY \_SASeller
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(selected_sellers)

         ENTITY SASale BY \_SAInfo
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(selected_infos)

         ENTITY SASale BY \_SASold
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(selected_materials).

    check_general( selected_sales     = selected_sales
                   selected_materials = selected_materials
                   selected_infos     = selected_infos
                   logger             = logger ).

    check_sellers( selected_sellers = selected_sellers
                   logger           = logger ).

    logger->save( ).

    MODIFY ENTITIES OF zbs_r_sasale IN LOCAL MODE
           ENTITY SASale
           UPDATE FIELDS ( LoggingId )
           WITH VALUE #( FOR key IN keys
                         ( %tky = key-%tky LoggingId = logger->get_log_handle( ) ) )
           FAILED DATA(failed_updates).

    RETURN xsdbool( failed_updates-sasale IS INITIAL ).
  ENDMETHOD.


  METHOD check_general.
    LOOP AT selected_sales INTO DATA(sale).
      IF    sale-DifferenceAmount IS NOT INITIAL AND sale-DifferenceQuantity IS NOT INITIAL
         OR sale-DifferenceAmount IS INITIAL     AND sale-DifferenceQuantity IS INITIAL.
        MESSAGE e001(zbs_demo_rap) INTO logger->message_text.
        logger->add_message_system( ).
      ENDIF.
    ENDLOOP.

    LOOP AT get_supported_languages( ) INTO DATA(supported_langauge).
      IF NOT line_exists( selected_infos[ Language = supported_langauge-language ] ).
        MESSAGE e005(zbs_demo_rap) WITH supported_langauge-language INTO logger->message_text.
        logger->add_message_system( ).
      ENDIF.
    ENDLOOP.

    IF selected_materials IS INITIAL.
      MESSAGE e003(zbs_demo_rap) INTO logger->message_text.
      logger->add_message_system( ).
    ENDIF.

    IF NOT logger->has_error( ).
      MESSAGE s007(zbs_demo_rap) INTO logger->message_text.
      logger->add_message_system( ).
    ENDIF.
  ENDMETHOD.


  METHOD check_sellers.
    LOOP AT selected_sellers INTO DATA(seller).
      IF seller-Confirmed IS INITIAL.
        MESSAGE e004(zbs_demo_rap) WITH seller-SellerId INTO logger->message_text.
        logger->add_message_system( ).
      ENDIF.
    ENDLOOP.

    SELECT FROM @selected_sellers AS table
      FIELDS SUM( Quota ) AS QuotaSum
      INTO @DATA(overall_sum).

    IF overall_sum <> 100.
      MESSAGE e002(zbs_demo_rap) INTO logger->message_text.
      logger->add_message_system( ).
    ENDIF.

    IF selected_sellers IS INITIAL.
      MESSAGE e003(zbs_demo_rap) INTO logger->message_text.
      logger->add_message_system( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
