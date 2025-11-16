CLASS lhc_Invoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Invoice RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Invoice RESULT result.

ENDCLASS.


CLASS lhc_Invoice IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD get_global_authorizations.
  ENDMETHOD.
ENDCLASS.


CLASS lsc_zbs_t_cdspatterninvoice DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS
      adjust_numbers REDEFINITION.

ENDCLASS.


CLASS lsc_zbs_t_cdspatterninvoice IMPLEMENTATION.
  METHOD adjust_numbers.
    SELECT SINGLE FROM ZBS_T_CDSPatternInvoice
      FIELDS MAX( DocumentNumber )
      INTO @DATA(max_number).

    LOOP AT mapped-invoice REFERENCE INTO DATA(new_invoice).
      max_number += 1.
      new_invoice->DocumentNumber = max_number.
    ENDLOOP.

    LOOP AT mapped-position REFERENCE INTO DATA(new_position).
      SELECT SINGLE FROM ZBS_T_CDSPatternPosition
        FIELDS MAX( PositionNumber )
        WHERE DocumentNumber = @new_position->%tmp-DocumentNumber
        INTO @DATA(max_position).

      new_position->DocumentNumber = new_position->%tmp-DocumentNumber.
      new_position->PositionNumber = max_position + 10.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
