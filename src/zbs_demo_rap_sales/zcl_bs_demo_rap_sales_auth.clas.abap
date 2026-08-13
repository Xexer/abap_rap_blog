CLASS zcl_bs_demo_rap_sales_auth DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF activities,
        create  TYPE activ_auth VALUE '01',
        change  TYPE activ_auth VALUE '02',
        display TYPE activ_auth VALUE '03',
        delete  TYPE activ_auth VALUE '06',
      END OF activities.

    "! Check if the user has authorization for the Activity and Partner ID
    "! @parameter activity   | Activity
    "! @parameter parnter_id | Partner ID (optional)
    "! @parameter result     | X = Auth ok, '' = No Auth
    METHODS has_authorization
      IMPORTING activity      TYPE activ_auth
                parnter_id    TYPE zbs_demo_sa_partner OPTIONAL
      RETURNING VALUE(result) TYPE abap_boolean.
ENDCLASS.


CLASS zcl_bs_demo_rap_sales_auth IMPLEMENTATION.
  METHOD has_authorization.
    IF parnter_id IS INITIAL.
      AUTHORITY-CHECK OBJECT 'ZBSDMOPART'
                      ID 'ACTVT' FIELD activity
                      ID 'ZBSDMOPART' DUMMY.
    ELSE.
      AUTHORITY-CHECK OBJECT 'ZBSDMOPART'
                      ID 'ACTVT' FIELD activity
                      ID 'ZBSDMOPART' FIELD parnter_id.
    ENDIF.

    RETURN xsdbool( sy-subrc = 0 ).
  ENDMETHOD.
ENDCLASS.
