CLASS zcl_bs_demo_eml_fields DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS create_with.
    METHODS create_from.
    METHODS create_with_more.
    METHODS create_from_more.
    METHODS update_with_less_fields.
    METHODS update_from_less_fields.
ENDCLASS.



CLASS ZCL_BS_DEMO_EML_FIELDS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    create_with( ).
    create_from( ).

    create_with_more( ).
    create_from_more( ).

    update_with_less_fields( ).
    update_from_less_fields( ).

    COMMIT ENTITIES.
  ENDMETHOD.


  METHOD create_with.
    MODIFY ENTITIES OF ZBS_I_RAPPartner
           ENTITY Partner CREATE FIELDS ( PartnerName Country )
           WITH VALUE #( ( PartnerName = 'TEST: WITH'
                           Country     = 'US' ) ).
  ENDMETHOD.


  METHOD create_from.
    MODIFY ENTITIES OF ZBS_I_RAPPartner
           ENTITY Partner CREATE
           FROM VALUE #( ( PartnerName          = 'TEST: FROM'
                           Country              = 'US'
                           %control-PartnerName = if_abap_behv=>mk-on
                           %control-Country     = if_abap_behv=>mk-on ) ).
  ENDMETHOD.


  METHOD create_with_more.
    MODIFY ENTITIES OF ZBS_I_RAPPartner
           ENTITY Partner CREATE FIELDS ( PartnerName Country )
           WITH VALUE #( ( PartnerName = 'TEST: WITH'
                           Country     = 'DE'
                           Street      = 'With-Street' ) ).
  ENDMETHOD.


  METHOD create_from_more.
    MODIFY ENTITIES OF ZBS_I_RAPPartner
           ENTITY Partner CREATE
           FROM VALUE #( ( PartnerName          = 'TEST: FROM'
                           Country              = 'DE'
                           Street               = 'From-Street'
                           %control-PartnerName = if_abap_behv=>mk-on
                           %control-Country     = if_abap_behv=>mk-on ) ).
  ENDMETHOD.


  METHOD update_with_less_fields.
    MODIFY ENTITIES OF ZBS_I_RAPPartner
           ENTITY Partner UPDATE FIELDS ( PartnerName Country )
           WITH VALUE #( ( PartnerNumber = '1000000018'
                           PartnerName   = ''
                           Street        = 'TEST: WITH2'
                           Country       = 'CH' ) ).
  ENDMETHOD.


  METHOD update_from_less_fields.
    MODIFY ENTITIES OF ZBS_I_RAPPartner
           ENTITY Partner UPDATE
           FROM VALUE #( ( PartnerNumber        = '1000000019'
                           PartnerName          = ''
                           Street               = 'TEST: FROM2'
                           Country              = 'CH'
                           %control-PartnerName = if_abap_behv=>mk-on
                           %control-Country     = if_abap_behv=>mk-on ) ).
  ENDMETHOD.
ENDCLASS.
