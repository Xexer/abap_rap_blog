CLASS zcl_bs_demo_hana_perf_test DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_bs_demo_hana_perf_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    TRY.
        SELECT FROM ZBS_X_DemoSQLPerformance
          FIELDS *
          INTO TABLE @DATA(remote_datas)
          UP TO 50 ROWS.

        out->write( remote_datas ).

      CATCH cx_root INTO DATA(sql_runtime).
        out->write( sql_runtime ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
