CLASS zcl_bs_demo_pattern_cds_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bs_demo_pattern_cds_data IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*    data headers type staNDARD TABLE OF ZBS_T_CDSPatternInvoice with emPTY KEY.
*    data positions type staNDARD TABLE OF ZBS_T_CDSPatternPosition with emPTY KEY.
*
*
*    delete from ZBS_T_CDSPatternInvoice.
*    delete from ZBS_T_CDSPatternPosition.
*
*    headers = value #(
*      (
*        DocumentNumber = ''
*        PartnerNumber = ''
*        DocumentDate = ''
*         = ''
*      )
*    ).
*
*    insert ZBS_T_CDSPatternInvoice from table @headers.
*    insert ZBS_T_CDSPatternPosition from table @positions.
  ENDMETHOD.
ENDCLASS.
