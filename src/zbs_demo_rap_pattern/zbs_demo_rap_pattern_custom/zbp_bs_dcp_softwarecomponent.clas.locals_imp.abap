CLASS lcl_buffer DEFINITION.
  PUBLIC SECTION.
    TYPES swc_updates TYPE TABLE FOR UPDATE zbs_r_dcpsoftwarecomponent\\swc.

    CLASS-DATA updates TYPE swc_updates.
ENDCLASS.


CLASS lhc_swc DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE swc.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR swc RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ swc RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK swc.

ENDCLASS.


CLASS lhc_swc IMPLEMENTATION.
  METHOD update.
    INSERT LINES OF entities INTO TABLE lcl_buffer=>updates.
  ENDMETHOD.


  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD read.
  ENDMETHOD.


  METHOD lock.
  ENDMETHOD.
ENDCLASS.


CLASS lsc_zbs_r_dcpsoftwarecomponent DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS
      save REDEFINITION.

ENDCLASS.


CLASS lsc_zbs_r_dcpsoftwarecomponent IMPLEMENTATION.
  METHOD save.
    LOOP AT lcl_buffer=>updates INTO DATA(update).
      INSERT zbs_dcp FROM @update MAPPING FROM ENTITY.
      IF sy-subrc <> 0.
        UPDATE zbs_dcp FROM @update INDICATORS SET STRUCTURE %control MAPPING FROM ENTITY.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
