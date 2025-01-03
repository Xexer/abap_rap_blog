CLASS zcl_bs_demo_eml_deep_action DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

*    TYPES: tt_document TYPE TABLE FOR ACTION IMPORT ZBS_R_RAPCInvoice~CreateInvoiceDocument.
    TYPES tt_document TYPE TABLE FOR ACTION IMPORT ZBS_R_RAPCInvoice~CreateMultipleInvoices.
ENDCLASS.


CLASS zcl_bs_demo_eml_deep_action IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
*    DATA lt_document TYPE tt_document.
*
*    lt_document = VALUE #( ( %cid   = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) )
*                             %param = VALUE #( Document  = 'TEST'
*                                               Partner   = '1000000004'
*                                               _position = VALUE #(
*                                                   Unit     = 'ST'
*                                                   Currency = 'EUR'
*                                                   ( Material = 'F0001' Quantity = '2' Price = '13.12' )
*                                                   ( Material = 'H0001' Quantity = '1' Price = '28.54' ) ) ) ) ).
*
*    MODIFY ENTITIES OF ZBS_R_RAPCInvoice
*           ENTITY Invoice
*           EXECUTE CreateInvoiceDocument FROM lt_document
*           FAILED DATA(ls_failed_deep)
*           REPORTED DATA(ls_reported_deep).

    DATA lt_document TYPE tt_document.

    INSERT VALUE #( %cid = xco_cp=>uuid( )->value ) INTO TABLE lt_document REFERENCE INTO DATA(lr_new_item).

    lr_new_item->%param = VALUE #( Partner = '1000000004'
                                   ( Document  = 'TEST'
                                     _position = VALUE #( Unit     = 'ST'
                                                          Currency = 'EUR'
                                                          ( Material = 'F0001' Quantity = '2' Price = '13.12' )
                                                          ( Material = 'H0001' Quantity = '1' Price = '28.54' ) ) )
                                   ( Document  = 'TEST2'
                                     _position = VALUE #( Unit     = 'ST'
                                                          Currency = 'USD'
                                                          ( Material = 'G0001' Quantity = '2' Price = '17.12' )
                                                          ( Material = 'Z0001' Quantity = '1' Price = '29.55' ) ) ) ).

    MODIFY ENTITIES OF ZBS_R_RAPCInvoice
           ENTITY Invoice
           EXECUTE CreateMultipleInvoices FROM lt_document
           FAILED DATA(ls_failed_deep)
           REPORTED DATA(ls_reported_deep).
  ENDMETHOD.
ENDCLASS.
