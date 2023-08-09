CLASS zcl_bs_demo_rap_data_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES zif_bs_demo_rap_data_handler.

    CLASS-METHODS create_instance
      RETURNING VALUE(ro_result) TYPE REF TO zif_bs_demo_rap_data_handler.
ENDCLASS.


CLASS zcl_bs_demo_rap_data_handler IMPLEMENTATION.
  METHOD create_instance.
    ro_result = NEW zcl_bs_demo_rap_data_handler( ).
  ENDMETHOD.


  METHOD zif_bs_demo_rap_data_handler~delete.
    DELETE FROM zbs_dmo_un_data WHERE gen_key = @id_key.

    rd_result = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


  METHOD zif_bs_demo_rap_data_handler~modify.
    DATA(ls_data) = is_data.
    GET TIME STAMP FIELD ls_data-last_changed.

    IF ls_data-gen_key IS INITIAL.
      TRY.
          ls_data-gen_key = cl_system_uuid=>create_uuid_x16_static( ).

          IF ls_data-cdate IS INITIAL.
            ls_data-cdate = cl_abap_context_info=>get_system_date( ).
          ENDIF.

        CATCH cx_uuid_error.
          rd_result = abap_false.
          RETURN.
      ENDTRY.

      INSERT zbs_dmo_un_data FROM @ls_data.

    ELSE.
      UPDATE zbs_dmo_un_data FROM @ls_data.

    ENDIF.

    rd_result = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


  METHOD zif_bs_demo_rap_data_handler~query.
    SELECT FROM zbs_dmo_un_data
      FIELDS *
      WHERE gen_key IN @it_r_key
        AND text IN @it_r_text
        AND cdate IN @it_r_date
      INTO TABLE @rt_result.
  ENDMETHOD.


  METHOD zif_bs_demo_rap_data_handler~read.
    SELECT SINGLE FROM zbs_dmo_un_data
      FIELDS *
      WHERE gen_key = @id_key
      INTO @rs_result.
  ENDMETHOD.
ENDCLASS.
