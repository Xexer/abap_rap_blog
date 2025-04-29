CLASS zcl_bs_dcp_swc_query DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

  PRIVATE SECTION.
    TYPES software_components TYPE STANDARD TABLE OF ZBS_R_DCPSoftwareComponent WITH EMPTY KEY.

    METHODS get_remote_data
      IMPORTING !request      TYPE REF TO if_rap_query_request
      EXPORTING business_data TYPE software_components
                !count        TYPE int8.

    METHODS adjust_data
      IMPORTING !request            TYPE REF TO if_rap_query_request
      CHANGING  software_components TYPE zcl_bs_dcp_swc_query=>software_components.
ENDCLASS.


CLASS zcl_bs_dcp_swc_query IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    get_remote_data( EXPORTING request       = io_request
                     IMPORTING business_data = DATA(software_components)
                               count         = DATA(count) ).

    adjust_data( EXPORTING request             = io_request
                 CHANGING  software_components = software_components ).

    IF io_request->is_data_requested( ).
      io_response->set_data( software_components ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( count ).
    ENDIF.
  ENDMETHOD.


  METHOD get_remote_data.
    DATA test_stage TYPE zbs_dcp-staging.

    TRY.
        DATA(filters) = request->get_filter( )->get_as_ranges( ).
        test_stage = filters[ name = `STAGING` ]-range[ 1 ]-low.
      CATCH cx_rap_query_filter_no_range.
        test_stage = 'TEST'.
    ENDTRY.

    NEW zcl_bs_demo_custom_git( )->get_software_component(
      EXPORTING setting       = VALUE #( entity_name   = 'REPOSITORIES'
                                         request       = request
                                         delete_fields = VALUE #( ( `STAGING` )
                                                                  ( `INFORMATION` )
                                                                  ( `APPLDESCRIPTION` )
                                                                  ( `TEAMDESCRIPTION` )
                                                                  ( `APPLICATION` )
                                                                  ( `TEAM` ) ) )
      IMPORTING business_data = DATA(remote_data)
                count         = count ).

    LOOP AT remote_data INTO DATA(remote).
      INSERT CORRESPONDING #( remote ) INTO TABLE business_data REFERENCE INTO DATA(line).

      SELECT SINGLE FROM zbs_dcp
        FIELDS information, application, team
        WHERE     staging = @test_stage
              AND sc_name = @line->sc_name
        INTO CORRESPONDING FIELDS OF @line->*.

      SELECT SINGLE FROM ZBS_I_DCPTeamVH
        FIELDS Description
        WHERE Team = @line->team
        INTO @line->TeamDescription.

      SELECT SINGLE FROM ZBS_I_DCPApplicationVH
        FIELDS Description
        WHERE Application = @line->application
        INTO @line->ApplDescription.

      line->staging = test_stage.
    ENDLOOP.
  ENDMETHOD.


  METHOD adjust_data.
    DATA(adjust_custom) = NEW zcl_bs_demo_adjust_data( ).

    TRY.
        DATA(filter) = request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        CLEAR filter.
    ENDTRY.

    adjust_custom->filter_data( EXPORTING it_filter = filter
                                CHANGING  ct_data   = software_components ).

    adjust_custom->order_data( EXPORTING it_sort = request->get_sort_elements( )
                               CHANGING  ct_data = software_components ).
  ENDMETHOD.
ENDCLASS.
