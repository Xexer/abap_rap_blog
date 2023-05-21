CLASS zcl_bs_demo_read_func DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      c_destination TYPE string VALUE `<destination-service-id>`.
ENDCLASS.



CLASS ZCL_BS_DEMO_READ_FUNC IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    TRY.
        DATA(lo_destination) = cl_rfc_destination_provider=>create_by_cloud_destination( c_destination ).

        NEW zbs_demo_rap_onprem_func( lo_destination )->z_bs_demo_get_cnames(
          EXPORTING
            id_branch = ''
            id_name   = ''
          IMPORTING
            ed_error  = DATA(ld_error)
            et_cnames = DATA(lt_company_names)
        ).

        out->write( 'Error from backend:' ).
        out->write( ld_error ).
        out->write( 'Companies:' ).
        out->write( lt_company_names ).

      CATCH cx_root INTO DATA(lo_error).
        out->write( lo_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
