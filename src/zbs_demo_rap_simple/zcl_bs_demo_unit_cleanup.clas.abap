CLASS zcl_bs_demo_unit_cleanup DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BS_DEMO_UNIT_CLEANUP IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DELETE FROM zbs_dmo_partner
      WHERE name = 'Do it Yourself'.

    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
