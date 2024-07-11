CLASS lhc_zbs_r_dmolanguage DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING
                 REQUEST requested_authorizations FOR Language
              RESULT result.

    METHODS TranslateText FOR MODIFY
      IMPORTING keys FOR ACTION Language~TranslateText RESULT result.
ENDCLASS.


CLASS lhc_zbs_r_dmolanguage IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD TranslateText.
    READ ENTITIES OF ZBS_R_DMOLanguage IN LOCAL MODE
         ENTITY Language ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_selected).

    LOOP AT lt_selected INTO DATA(ls_selected) WHERE TargetLanguage IS NOT INITIAL.
      DATA(ld_translated) = NEW zcl_bs_demo_google_integration( )->translate_text(
          id_target_language = to_lower( ls_selected-TargetLanguage )
          id_text            = CONV #( ls_selected-SourceText ) ).

      MODIFY ENTITIES OF ZBS_R_DMOLanguage IN LOCAL MODE
             ENTITY Language UPDATE FROM VALUE #( ( %tky                = ls_selected-%tky
                                                    targettext          = ld_translated
                                                    %control-targettext = if_abap_behv=>mk-on ) )
             FAILED DATA(ls_failed).

      IF ls_failed-language IS INITIAL.
        INSERT VALUE #( %tky = ls_selected-%tky ) INTO TABLE mapped-language.
      ELSE.
        INSERT VALUE #( %tky = ls_selected-%tky ) INTO TABLE failed-language.
        INSERT VALUE #( %tky = ls_selected-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = 'Error while updating the data' ) )
               INTO TABLE reported-language.
      ENDIF.
    ENDLOOP.

    READ ENTITIES OF ZBS_R_DMOLanguage IN LOCAL MODE
         ENTITY Language ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_new).

    result = VALUE #( FOR ls_new IN lt_new
                      ( %tky = ls_new-%tky %param = ls_new )  ).
  ENDMETHOD.
ENDCLASS.
