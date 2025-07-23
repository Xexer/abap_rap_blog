CLASS lcl_data_buffer DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA updates TYPE TABLE FOR UPDATE zbs_r_cusactentitytp\\customaction.
    CLASS-DATA reset   TYPE abap_boolean.
ENDCLASS.


CLASS lhc_CustomAction DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR CustomAction RESULT result.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE CustomAction.

    METHODS read FOR READ
      IMPORTING keys FOR READ CustomAction RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK CustomAction.

    METHODS myCustomAction FOR MODIFY
      IMPORTING keys FOR ACTION CustomAction~myCustomAction RESULT result.

    METHODS resetAllIcons FOR MODIFY
      IMPORTING keys FOR ACTION CustomAction~resetAllIcons.
ENDCLASS.


CLASS lhc_CustomAction IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD update.
    INSERT LINES OF entities INTO TABLE lcl_data_buffer=>updates.
  ENDMETHOD.


  METHOD read.
    DATA(all) = NEW zcl_bs_demo_custom_action_qry( )->get_dummy_data( ).

    LOOP AT keys INTO DATA(key).
      INSERT CORRESPONDING #( all[ my_key = key-my_key ] ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.


  METHOD lock.
  ENDMETHOD.


  METHOD myCustomAction.
    READ ENTITIES OF ZBS_R_CusActEntityTP IN LOCAL MODE
         ENTITY CustomAction
         FROM CORRESPONDING #( keys )
         RESULT DATA(found_data).

    LOOP AT found_data INTO DATA(found).
      MODIFY ENTITIES OF ZBS_R_CusActEntityTP IN LOCAL MODE
             ENTITY CustomAction
             UPDATE FROM VALUE #( ( my_key               = found-my_key
                                    description          = found-description
                                    %control-description = if_abap_behv=>mk-on ) ).

      INSERT VALUE #( my_key = found-my_key
                      %param = found ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.


  METHOD resetAllIcons.
    lcl_data_buffer=>reset = abap_true.
  ENDMETHOD.
ENDCLASS.


CLASS lsc_ZBS_R_CUSACTENTITYTP DEFINITION INHERITING FROM cl_abap_behavior_saver.
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


CLASS lsc_ZBS_R_CUSACTENTITYTP IMPLEMENTATION.
  METHOD finalize.
  ENDMETHOD.


  METHOD check_before_save.
  ENDMETHOD.


  METHOD save.
    LOOP AT lcl_data_buffer=>updates INTO DATA(update).
      SELECT SINGLE FROM zbs_dmo_cstat
        FIELDS status
        WHERE my_key = @update-my_key
        INTO @DATA(found_status).

      IF sy-subrc <> 0.
        INSERT zbs_dmo_cstat FROM @( VALUE #( my_key = update-my_key
                                              status = 1 ) ).
      ELSE.
        UPDATE zbs_dmo_cstat FROM @( VALUE #( my_key = update-my_key
                                              status = found_status + 1 ) ).
      ENDIF.
    ENDLOOP.

    IF lcl_data_buffer=>reset = abap_true.
      DELETE FROM zbs_dmo_cstat.
    ENDIF.
  ENDMETHOD.


  METHOD cleanup.
  ENDMETHOD.


  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
