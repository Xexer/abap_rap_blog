CLASS lhc_Currency DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Currency RESULT result.

ENDCLASS.


CLASS lhc_Currency IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.
ENDCLASS.


CLASS lsc_ZBS_R_DRPCURRENCY DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS
      save_modified REDEFINITION.

    METHODS
      cleanup_finalize REDEFINITION.

ENDCLASS.


CLASS lsc_ZBS_R_DRPCURRENCY IMPLEMENTATION.
  METHOD save_modified.
    LOOP AT update-currency INTO DATA(ls_new_currency).
      DATA(ls_modify_currency) = CORRESPONDING zbs_drp_addcurr( ls_new_currency MAPPING FROM ENTITY ).
      ls_modify_currency-last_editor = cl_abap_context_info=>get_user_technical_name( ).
      MODIFY zbs_drp_addcurr FROM @ls_modify_currency.
    ENDLOOP.

    LOOP AT create-country INTO DATA(ls_create_country).
      INSERT zbs_drp_country FROM @( CORRESPONDING zbs_drp_country( ls_create_country MAPPING FROM ENTITY ) ).
    ENDLOOP.

    LOOP AT update-country INTO DATA(ls_update_country).
      UPDATE zbs_drp_country FROM @( CORRESPONDING zbs_drp_country( ls_update_country MAPPING FROM ENTITY ) ).
    ENDLOOP.

    LOOP AT delete-country INTO DATA(ls_delete_country).
      DELETE zbs_drp_country FROM @( CORRESPONDING zbs_drp_country( ls_delete_country MAPPING FROM ENTITY ) ).
    ENDLOOP.
  ENDMETHOD.


  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
