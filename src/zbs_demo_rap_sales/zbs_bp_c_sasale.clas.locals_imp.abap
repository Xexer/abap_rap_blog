CLASS lhc_sasale DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF text,
        Language        TYPE zbs_r_sainfo-Language,
        TextInformation TYPE zbs_r_sainfo-TextInformation,
      END OF text.
    TYPES texts TYPE STANDARD TABLE OF text WITH EMPTY KEY.

    METHODS augment_create FOR MODIFY
      IMPORTING entities FOR CREATE SASale.

    METHODS augment_update FOR MODIFY
      IMPORTING entities FOR UPDATE SASale.

    METHODS translate_text
      IMPORTING !text         TYPE zbs_r_sainfo-TextInformation
      RETURNING VALUE(result) TYPE texts.

    METHODS get_supported_languages
      RETURNING VALUE(result) TYPE texts.
ENDCLASS.


CLASS lhc_sasale IMPLEMENTATION.
  METHOD augment_create.
    LOOP AT entities INTO DATA(entity).
      DATA(texts) = get_supported_languages( ).

      MODIFY AUGMENTING ENTITIES OF zbs_r_sasale
             ENTITY SASale
             CREATE BY \_SAInfo AUTO FILL CID FIELDS ( Language )
             WITH VALUE #( ( %cid_ref  = entity-%cid
                             %is_draft = entity-%is_draft
                             %target   = VALUE #( FOR  translated_text IN texts
                                                  ( %is_draft = entity-%is_draft
                                                    Language  = translated_text-language ) ) ) ).

    ENDLOOP.
  ENDMETHOD.


  METHOD augment_update.
    READ ENTITIES OF zbs_r_sasale
         ENTITY SASale BY \_SAInfo
         FROM CORRESPONDING #( entities )
         RESULT DATA(found_languages).

    LOOP AT entities INTO DATA(entity).
      LOOP AT translate_text( entity-TextInformation ) INTO DATA(text).
        IF line_exists( found_languages[ ParentUUID = entity-uuid
                                         Language   = TEXT-language ] ).
          MODIFY AUGMENTING ENTITIES OF zbs_r_sasale
                 ENTITY SAInfo
                 UPDATE FIELDS ( TextInformation )
                 WITH VALUE #( ( %tky-%is_draft  = entity-%tky-%is_draft
                                 %tky-parentuuid = entity-%tky-uuid
                                 %tky-Language   = TEXT-language
                                 TextInformation = TEXT-textinformation ) ).
        ELSE.
          MODIFY AUGMENTING ENTITIES OF zbs_r_sasale
                 ENTITY SASale
                 CREATE BY \_SAInfo AUTO FILL CID FIELDS ( Language TextInformation )
                 WITH VALUE #( ( %tky    = CORRESPONDING #( entity-%tky )
                                 %target = VALUE #( ( %is_draft       = entity-%is_draft
                                                      Language        = TEXT-language
                                                      TextInformation = TEXT-textinformation ) ) ) ).
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD translate_text.
    result = get_supported_languages( ).

    DATA(translate) = NEW zcl_bs_demo_google_integration( ).

    LOOP AT result REFERENCE INTO DATA(line).
      IF line->language = sy-langu.
        line->textinformation = text.
      ELSE.
        DATA(iso_language) = xco_cp=>language( line->language )->as( xco_cp_language=>format->iso_639 ).
        line->textinformation = translate->translate_text( id_text            = CONV #( text )
                                                           id_target_language = to_lower( iso_language ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_supported_languages.
    RETURN VALUE #( ( language = 'D' )
                    ( language = 'E' )
                    ( language = 'F' )
                    ( language = 'I' ) ).
  ENDMETHOD.
ENDCLASS.
