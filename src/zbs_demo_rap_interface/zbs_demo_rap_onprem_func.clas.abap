CLASS zbs_demo_rap_onprem_func DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_aco_proxy .

    TYPES:
      _c_000050                      TYPE c LENGTH 000050 ##TYPSHADOW .
    TYPES:
      _c_000060                      TYPE c LENGTH 000060 ##TYPSHADOW .
    TYPES:
      BEGIN OF zbs_dmo_cname                 ,
        client      TYPE c LENGTH 000003,
        name        TYPE c LENGTH 000060,
        branch      TYPE c LENGTH 000050,
        description TYPE c LENGTH 000255,
      END OF zbs_dmo_cname                  ##TYPSHADOW .
    TYPES:
      zbs_t_demo_cnames              TYPE STANDARD TABLE OF zbs_dmo_cname                  WITH DEFAULT KEY ##TYPSHADOW .

    METHODS constructor
      IMPORTING
        !destination TYPE REF TO if_rfc_dest
      RAISING
        cx_rfc_dest_provider_error .
    METHODS z_bs_demo_get_cnames
      IMPORTING
        !id_branch TYPE _c_000050
        !id_name   TYPE _c_000060
      EXPORTING
        !ed_error  TYPE string
        !et_cnames TYPE zbs_t_demo_cnames
      RAISING
        cx_aco_application_exception
        cx_aco_communication_failure
        cx_aco_system_failure .
  PROTECTED SECTION.

    DATA destination TYPE rfcdest .
  PRIVATE SECTION.
ENDCLASS.



CLASS zbs_demo_rap_onprem_func IMPLEMENTATION.


  METHOD constructor.
    me->destination = destination->get_destination_name( ).
  ENDMETHOD.


  METHOD z_bs_demo_get_cnames.
    DATA: _rfc_message_ TYPE aco_proxy_msg_type.
    CALL FUNCTION 'Z_BS_DEMO_GET_CNAMES' DESTINATION me->destination
      EXPORTING
        id_branch             = id_branch
        id_name               = id_name
      IMPORTING
        ed_error              = ed_error
        et_cnames             = et_cnames
      EXCEPTIONS
        communication_failure = 1 MESSAGE _rfc_message_
        system_failure        = 2 MESSAGE _rfc_message_
        OTHERS                = 3.
    IF sy-subrc NE 0.
      DATA __sysubrc TYPE sy-subrc.
      DATA __textid TYPE aco_proxy_textid_type.
      __sysubrc = sy-subrc.
      __textid-msgid = sy-msgid.
      __textid-msgno = sy-msgno.
      __textid-attr1 = sy-msgv1.
      __textid-attr2 = sy-msgv2.
      __textid-attr3 = sy-msgv3.
      __textid-attr4 = sy-msgv4.
      CASE __sysubrc.
        WHEN 1 .
          RAISE EXCEPTION TYPE cx_aco_communication_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 2 .
          RAISE EXCEPTION TYPE cx_aco_system_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 3 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'OTHERS'
              textid       = __textid.
      ENDCASE.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
