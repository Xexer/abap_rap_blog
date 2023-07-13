CLASS lhc_Invoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Invoice RESULT result.

    METHODS sendtestmail FOR MODIFY
      IMPORTING keys FOR ACTION invoice~sendtestmail.

    METHODS send_mail_with_attachement
      IMPORTING id_mail_content TYPE string
                id_receiver     TYPE cl_bcs_mail_message=>ty_address.
ENDCLASS.


CLASS lhc_Invoice IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD sendTestMail.
    READ ENTITIES OF ZBS_R_RAPCInvoice IN LOCAL MODE
         ENTITY Invoice
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_invoice).

    DATA(ld_mail_content) = ``.
    LOOP AT lt_invoice INTO DATA(ls_invoice).
      ld_mail_content &&= |Doc: { ls_invoice-Document }, From: { ls_invoice-Partner }\n|.
    ENDLOOP.

    send_mail_with_attachement( id_mail_content = ld_mail_content
                                id_receiver     = keys[ 1 ]-%param-ReceiverMail ).
  ENDMETHOD.


  METHOD send_mail_with_attachement.
    DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).

    lo_mail->set_sender( 'BTP-noreply@CONNECT.com' ).
    lo_mail->add_recipient( id_receiver ).

    lo_mail->set_subject( 'Invoices' ).
    lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
        iv_content      = '<h1>List of invoices</h1><p>See the attachment with the selected invoices.</p>'
        iv_content_type = 'text/html' ) ).

    lo_mail->add_attachment( cl_bcs_mail_textpart=>create_instance( iv_content      = id_mail_content
                                                                    iv_content_type = 'text/plain'
                                                                    iv_filename     = 'Attachment.txt' ) ).

    lo_mail->send( ).
  ENDMETHOD.
ENDCLASS.
