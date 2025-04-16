CLASS zcl_bs_demo_crap_eml DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF header,
        document TYPE ZBS_R_RAPCInvoice-Document,
        partner  TYPE ZBS_R_RAPCInvoice-Partner,
      END OF header.

    TYPES:
      BEGIN OF position,
        pos      TYPE ZBS_I_RAPCPosition-PositionNumber,
        material TYPE ZBS_I_RAPCPosition-Material,
        price    TYPE ZBS_I_RAPCPosition-Price,
        currency TYPE ZBS_I_RAPCPosition-Currency,
      END OF position.
    TYPES positions TYPE STANDARD TABLE OF position WITH EMPTY KEY.

    TYPES:
      BEGIN OF multiple,
        header    TYPE header,
        positions TYPE positions,
      END OF multiple.

    METHODS read_data
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS insert_data
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS delete_data
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS create_generic
      IMPORTING !data TYPE multiple.
ENDCLASS.


CLASS zcl_bs_demo_crap_eml IMPLEMENTATION.
  METHOD delete_data.
    DATA lt_filter TYPE STANDARD TABLE OF ZBS_R_RAPCInvoice WITH EMPTY KEY.

    lt_filter = VALUE #( ( Document = '40000000' ) ).

    MODIFY ENTITIES OF ZBS_R_RAPCInvoice
           ENTITY Invoice
           DELETE FROM CORRESPONDING #( lt_filter )
           FAILED DATA(ls_failed).

    COMMIT ENTITIES.

    IF ls_failed-invoice IS NOT INITIAL.
      io_out->write( `Failed!` ).
    ELSE.
      io_out->write( `Deletion OK` ).
    ENDIF.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    read_data( out ).
    insert_data( out ).
    delete_data( out ).
  ENDMETHOD.


  METHOD insert_data.
    DATA lt_new_invoice  TYPE TABLE FOR CREATE ZBS_R_RAPCInvoice.
    DATA lt_new_position TYPE TABLE FOR CREATE ZBS_R_RAPCInvoice\_Position.

    lt_new_invoice = VALUE #( ( %cid     = 'B0'
                                Document = '40000000'
                                Partner  = '1000000004'
                                %control = VALUE #( Document = if_abap_behv=>mk-on
                                                    Partner  = if_abap_behv=>mk-on ) ) ).

    lt_new_position = VALUE #( ( %cid_ref = 'B0'
                                 %target  = VALUE #(
                                     ( %cid           = 'P1'
                                       PositionNumber = 1
                                       Material       = 'R0001'
                                       %control       = VALUE #( PositionNumber = if_abap_behv=>mk-on
                                                                 Material       = if_abap_behv=>mk-on ) )
                                     ( %cid           = 'P2'
                                       PositionNumber = 2
                                       Price          = '2.20'
                                       Currency       = 'EUR'
                                       %control       = VALUE #( PositionNumber = if_abap_behv=>mk-on
                                                                 Price          = if_abap_behv=>mk-on
                                                                 Currency       = if_abap_behv=>mk-on ) ) ) ) ).

    MODIFY ENTITIES OF ZBS_R_RAPCInvoice
           ENTITY Invoice
           CREATE FROM lt_new_invoice
           ENTITY Invoice
           CREATE BY \_Position FROM lt_new_position
           FAILED DATA(ls_failed).

    COMMIT ENTITIES.

    IF ls_failed-invoice IS NOT INITIAL.
      io_out->write( `Failed!` ).
    ELSE.
      io_out->write( `Creation OK` ).
    ENDIF.
  ENDMETHOD.


  METHOD read_data.
    DATA lt_filter TYPE STANDARD TABLE OF ZBS_R_RAPCInvoice WITH EMPTY KEY.

    lt_filter = VALUE #( ( Document = '30000000' )
                         ( Document = '30000005' ) ).

    READ ENTITIES OF ZBS_R_RAPCInvoice
         ENTITY Invoice
         ALL FIELDS WITH CORRESPONDING #( lt_filter )
         RESULT DATA(lt_invoice)
         ENTITY Invoice BY \_Position
         FIELDS ( Document PositionNumber Material ) WITH CORRESPONDING #( lt_filter )
         RESULT DATA(lt_position)
         FAILED FINAL(ls_failed).

    IF ls_failed-invoice IS NOT INITIAL.
      io_out->write( `Failed!` ).
    ENDIF.

    io_out->write( `Invoices:` ).
    io_out->write( lt_invoice ).
    io_out->write( `Positions:` ).
    io_out->write( lt_position ).
  ENDMETHOD.


  METHOD create_generic.
    DATA new_invoices  TYPE TABLE FOR CREATE ZBS_R_RAPCInvoice.
    DATA new_positions TYPE TABLE FOR CREATE ZBS_R_RAPCInvoice\_Position.

    INSERT VALUE #( %cid              = xco_cp=>uuid( )->value
                    Document          = data-header-document
                    Partner           = data-header-partner
                    %control-Document = if_abap_behv=>mk-on
                    %control-Partner  = if_abap_behv=>mk-on ) INTO TABLE new_invoices REFERENCE INTO DATA(actual_invoice).

    INSERT VALUE #( %cid_ref = actual_invoice->%cid ) INTO TABLE new_positions REFERENCE INTO DATA(actual_position).

    LOOP AT data-positions INTO DATA(position).
      INSERT VALUE #( %cid                    = xco_cp=>uuid( )->value
                      PositionNumber          = position-pos
                      Price                   = position-price
                      Currency                = position-currency
                      %control-PositionNumber = if_abap_behv=>mk-on
                      %control-Material       = if_abap_behv=>mk-on
                      %control-Price          = if_abap_behv=>mk-on
                      %control-Currency       = if_abap_behv=>mk-on ) INTO TABLE actual_position->%target.
    ENDLOOP.

    MODIFY ENTITIES OF ZBS_R_RAPCInvoice
           ENTITY Invoice
           CREATE FROM new_invoices
           ENTITY Invoice
           CREATE BY \_Position FROM new_positions.
  ENDMETHOD.
ENDCLASS.
