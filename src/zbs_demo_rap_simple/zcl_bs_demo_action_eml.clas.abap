CLASS zcl_bs_demo_action_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BS_DEMO_ACTION_EML IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    MODIFY ENTITIES OF ZBS_I_RAPPartner
      ENTITY Partner EXECUTE fillEmptyStreets
      FROM VALUE #( ( PartnerNumber = '1000000007' ) )
      RESULT DATA(lt_new_partner)
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    COMMIT ENTITIES.

    IF line_exists( lt_new_partner[ 1 ] ).
      out->write( lt_new_partner[ 1 ]-PartnerNumber ).
      out->write( lt_new_partner[ 1 ]-%param ).
    ELSE.
      out->write( `Not worked` ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
