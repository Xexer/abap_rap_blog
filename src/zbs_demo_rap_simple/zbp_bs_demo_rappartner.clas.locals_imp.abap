CLASS lhc_Partner DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Partner RESULT result.

    METHODS validatekeyisfilled FOR VALIDATE ON SAVE
      IMPORTING keys FOR partner~validatekeyisfilled.

    METHODS validatecoredata FOR VALIDATE ON SAVE
      IMPORTING keys FOR partner~validatecoredata.

    METHODS fillcurrency FOR DETERMINE ON MODIFY
      IMPORTING keys FOR partner~fillcurrency.

    METHODS clearallemptystreets FOR MODIFY
      IMPORTING keys FOR ACTION partner~clearallemptystreets.

    METHODS fillemptystreets FOR MODIFY
      IMPORTING keys FOR ACTION partner~fillemptystreets.
ENDCLASS.

CLASS lhc_Partner IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD validateKeyIsFilled.
    LOOP AT keys INTO DATA(ls_key) WHERE PartnerNumber IS INITIAL.
      INSERT VALUE #( PartnerNumber = ls_key-PartnerNumber ) INTO TABLE failed-partner.

      INSERT VALUE #(
        PartnerNumber = ls_key-PartnerNumber
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'PartnerNumber is mandatory' )
      ) INTO TABLE reported-partner.
    ENDLOOP.
  ENDMETHOD.


  METHOD validateCoreData.
    READ ENTITIES OF ZBS_I_RAPPartner IN LOCAL MODE
      ENTITY Partner
      FIELDS ( Country PaymentCurrency )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_partner_data)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    LOOP AT lt_partner_data INTO DATA(ls_partner).
      SELECT SINGLE FROM I_Country
        FIELDS Country
        WHERE Country = @ls_partner-Country
        INTO @DATA(ld_found_country).
      IF sy-subrc <> 0.
        INSERT VALUE #( PartnerNumber = ls_partner-PartnerNumber ) INTO TABLE failed-partner.

        INSERT VALUE #(
          PartnerNumber = ls_partner-PartnerNumber
           %msg = new_message_with_text( text = 'Country not found in I_Country' )
           %element-country = if_abap_behv=>mk-on
        ) INTO TABLE reported-partner.
      ENDIF.

      SELECT SINGLE FROM I_Currency
        FIELDS Currency
        WHERE Currency = @ls_partner-PaymentCurrency
        INTO @DATA(ld_found_currency).
      IF sy-subrc <> 0.
        INSERT VALUE #( PartnerNumber = ls_partner-PartnerNumber ) INTO TABLE failed-partner.

        INSERT VALUE #(
          PartnerNumber = ls_partner-PartnerNumber
           %msg = new_message_with_text( text = 'Currency not found in I_Currency' )
           %element-paymentcurrency = if_abap_behv=>mk-on
        ) INTO TABLE reported-partner.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD fillCurrency.
    READ ENTITIES OF ZBS_I_RAPPartner IN LOCAL MODE
      ENTITY Partner
      FIELDS ( PaymentCurrency )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_partner_data).

    LOOP AT lt_partner_data INTO DATA(ls_partner) WHERE PaymentCurrency IS INITIAL.
      MODIFY ENTITIES OF ZBS_I_RAPPartner IN LOCAL MODE
        ENTITY Partner
        UPDATE FIELDS ( PaymentCurrency )
        WITH VALUE #( ( %tky = ls_partner-%tky PaymentCurrency = 'EUR' %control-paymentcurrency = if_abap_behv=>mk-on ) ).
    ENDLOOP.
  ENDMETHOD.


  METHOD clearAllEmptyStreets.
    SELECT FROM zbs_dmo_partner
      FIELDS partner, street
      WHERE street = 'EMPTY'
      INTO TABLE @DATA(lt_partner_data).

    LOOP AT lt_partner_data INTO DATA(ls_partner).
      MODIFY ENTITIES OF ZBS_I_RAPPartner IN LOCAL MODE
        ENTITY Partner
        UPDATE FIELDS ( Street )
        WITH VALUE #( ( PartnerNumber = ls_partner-partner Street = '' %control-Street = if_abap_behv=>mk-on ) ).
    ENDLOOP.

    INSERT VALUE #(
      %msg = new_message_with_text( text = |{ lines( lt_partner_data ) } records changed|
      severity = if_abap_behv_message=>severity-success )
    ) INTO TABLE reported-partner.
  ENDMETHOD.


  METHOD fillEmptyStreets.
    READ ENTITIES OF ZBS_I_RAPPartner IN LOCAL MODE
      ENTITY Partner
      FIELDS ( Street )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_partner_data).

    LOOP AT lt_partner_data INTO DATA(ls_partner) WHERE Street IS INITIAL.
      MODIFY ENTITIES OF ZBS_I_RAPPartner IN LOCAL MODE
        ENTITY Partner
        UPDATE FIELDS ( Street )
        WITH VALUE #( ( %tky = ls_partner-%tky Street = 'EMPTY' %control-Street = if_abap_behv=>mk-on ) ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
