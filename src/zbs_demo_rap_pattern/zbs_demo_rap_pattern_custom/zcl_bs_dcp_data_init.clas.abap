CLASS zcl_bs_dcp_data_init DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_bs_dcp_data_init IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA teams        TYPE SORTED TABLE OF zbs_dcp_team WITH UNIQUE KEY team.
    DATA applications TYPE SORTED TABLE OF zbs_dcp_appl WITH UNIQUE KEY application.

    teams = VALUE #( ( team = 'BASE_DEV' description = 'Central Development' )
                     ( team = 'FI_DEV' description = 'Development Financial' )
                     ( team = 'HR_CUST' description = 'HR Customizing' ) ).

    DELETE FROM zbs_dcp_team.
    INSERT zbs_dcp_team FROM TABLE @teams.

    applications = VALUE #( ( application = 'GENERAL' team = 'BASE_DEV' description = 'General Developments' )
                            ( application = 'REVIEW' team = 'BASE_DEV' description = 'Review Tool' )
                            ( application = 'CALC' team = 'FI_DEV' description = 'Tax Calculation' )
                            ( application = 'ENGINE' team = 'FI_DEV' description = 'Calculation engine' )
                            ( application = 'ACC_DEF' team = 'FI_DEV' description = 'Account definition' ) ).

    DELETE FROM zbs_dcp_appl.
    INSERT zbs_dcp_appl FROM TABLE @applications.
  ENDMETHOD.
ENDCLASS.
