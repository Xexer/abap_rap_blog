CLASS zcl_bs_demo_tilec_partnerapp DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_bs_demo_tilec.
ENDCLASS.


CLASS zcl_bs_demo_tilec_partnerapp IMPLEMENTATION.
  METHOD zif_bs_demo_tilec~get_configuration.
    SELECT FROM ZBS_C_RAPPartner
      FIELDS COUNT( * ) AS number
      INTO @DATA(total_partner_number).

    RETURN VALUE #( title         = 'Partner'
                    subtitle      = 'Dynamically loaded ...'
                    icon          = 'sap-icon://general-leave-request'
                    info          = ''
                    info_state    = zif_bs_demo_tilec=>info_state-neutral
                    number        = total_partner_number
                    number_digits = 0
                    number_factor = ''
                    number_state  = zif_bs_demo_tilec=>number_state-good
                    number_unit   = 'Custom Unit'
                    state_arrow   = zif_bs_demo_tilec=>arrow_state-up ).
  ENDMETHOD.
ENDCLASS.
