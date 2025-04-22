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
ENDCLASS.


CLASS zcl_bs_dcp_swc_query IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    get_remote_data( EXPORTING request       = io_request
                     IMPORTING business_data = DATA(software_components)
                               count         = DATA(count) ).

    IF io_request->is_data_requested( ).
      io_response->set_data( software_components ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( count ).
    ENDIF.
  ENDMETHOD.


  METHOD get_remote_data.
    NEW zcl_bs_demo_custom_git( )->get_software_component(
      EXPORTING setting       = VALUE #( entity_name = 'REPOSITORIES'
                                         request     = request )
      IMPORTING business_data = DATA(remote_data)
                count         = count ).

    business_data = CORRESPONDING #( remote_data ).
  ENDMETHOD.
ENDCLASS.
