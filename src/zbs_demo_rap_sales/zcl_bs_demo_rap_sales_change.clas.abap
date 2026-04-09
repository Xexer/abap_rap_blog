CLASS zcl_bs_demo_rap_sales_change DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS log_changes
      IMPORTING !out          TYPE REF TO if_oo_adt_classrun_out
      RETURNING VALUE(result) TYPE if_chdo_object_tools_rel=>ty_cdobjectv.

    METHODS read_changes
      IMPORTING object_id TYPE if_chdo_object_tools_rel=>ty_cdobjectv
                !out      TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.


CLASS zcl_bs_demo_rap_sales_change IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
*    log_changes( out ).
    read_changes( object_id = '1000AC4D0CC190F1FD18CEDD74021687162'
                  out       = out ).
  ENDMETHOD.


  METHOD log_changes.
    DATA old_sale  TYPE zbs_sasale.
    DATA new_sale  TYPE zbs_sasale.
    DATA object_id TYPE if_chdo_object_tools_rel=>ty_cdobjectv.

    old_sale = VALUE #( client             = sy-mandt
                        uuid               = xco_cp=>uuid( )->value
                        partnernumber      = '1000000000'
                        SalesDate          = '20260101'
                        SalesVolume        = '23000'
                        SalesCurrency      = 'EUR'
                        SaleComment        = `New year, new sales`
                        DifferenceAmount   = '15000'
                        DifferenceCurrency = 'EUR' ).

    new_sale = old_sale.
    new_sale-SalesDate   = '20260215'.
    new_sale-SalesVolume = '22500'.

    object_id = old_sale-client && old_sale-uuid.

    TRY.
        zcl_zbs_co_sales_chdo=>write(
          EXPORTING objectid       = object_id
                    utime          = cl_abap_context_info=>get_system_time( )
                    udate          = cl_abap_context_info=>get_system_date( )
                    username       = CONV #( cl_abap_context_info=>get_user_technical_name( ) )
                    o_zbs_sasale   = old_sale
                    n_zbs_sasale   = new_sale
                    upd_zbs_sasale = 'U'
          IMPORTING changenumber   = DATA(changenumber) ).

        out->write( changenumber ).

        result = object_id.
        COMMIT WORK.

      CATCH cx_chdo_write_error INTO DATA(error).
        out->write( error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD read_changes.
    TRY.
        cl_chdo_read_tools=>changedocument_read(
          EXPORTING i_objectclass   = zcl_zbs_co_sales_chdo=>objectclass
                    it_objectid     = VALUE #( ( sign = 'I' option = 'EQ' low = object_id ) )
          IMPORTING et_cdredadd_tab = DATA(db_changes) ).

        out->write( db_changes ).

      CATCH cx_chdo_read_error INTO DATA(error).
        out->write( error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
