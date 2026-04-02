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
