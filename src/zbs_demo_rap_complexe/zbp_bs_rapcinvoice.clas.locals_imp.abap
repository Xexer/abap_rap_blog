CLASS lhc_Invoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Invoice RESULT result.

ENDCLASS.


CLASS lhc_Invoice IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.
ENDCLASS.
