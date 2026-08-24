CLASS zcl_bs_demo_rap_singleton_db DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_bs_demo_rap_singleton_db IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zbs_tst_single.
    DELETE FROM zbs_tst_sinpa.
    DELETE FROM zbs_tst_singled.
    DELETE FROM zbs_tst_sinpad.
    DELETE FROM zbs_sin_result.
    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
