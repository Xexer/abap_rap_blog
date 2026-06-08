CLASS lsc_zbs_r_hybperformancedata DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS
      save_modified REDEFINITION.

ENDCLASS.


CLASS lsc_zbs_r_hybperformancedata IMPLEMENTATION.
  METHOD save_modified.
    LOOP AT update-performance INTO DATA(update_performance).
      SELECT SINGLE FROM zbs_hyb_perf_add
        FIELDS *
        WHERE identifier = @update_performance-Identifier
        INTO @DATA(db_base).

      DATA(modify_performance) = CORRESPONDING zbs_hyb_perf_add( BASE ( db_base ) update_performance MAPPING FROM ENTITY USING CONTROL ).
      modify_performance-identifier = update_performance-Identifier.

      MODIFY zbs_hyb_perf_add FROM @modify_performance.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_Performance DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Performance RESULT result.

ENDCLASS.


CLASS lhc_Performance IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.
ENDCLASS.
