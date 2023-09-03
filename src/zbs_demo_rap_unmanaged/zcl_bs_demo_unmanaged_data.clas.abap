CLASS zcl_bs_demo_unmanaged_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS ZCL_BS_DEMO_UNMANAGED_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA(lo_rap) = zcl_bs_demo_rap_data_handler=>create_instance( ).

    lo_rap->modify( VALUE #( text = 'Belgium' ) ).
    lo_rap->modify( VALUE #( text = 'Germany' ) ).
    lo_rap->modify( VALUE #( text = 'USA' ) ).

    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
