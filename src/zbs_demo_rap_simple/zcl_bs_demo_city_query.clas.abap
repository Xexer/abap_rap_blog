CLASS zcl_bs_demo_city_query DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.



CLASS ZCL_BS_DEMO_CITY_QUERY IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA lt_values TYPE STANDARD TABLE OF ZBS_I_RAPCityVH WITH EMPTY KEY.

    lt_values = VALUE #( ( City = 'Walldorf' CityShort = 'DE' )
                         ( City = 'Redmond' CityShort = 'US' )
                         ( City = 'Menlo Park' CityShort = 'US' )
                         ( City = 'Hangzhou' CityShort = 'CN' )
                         ( City = 'Munich' CityShort = 'DE' )
                         ( City = 'Vevey' CityShort = 'CH' )
                         ( City = 'Sankt Petersburg' CityShort = 'RU' )
                         ( City = 'Seattle' CityShort = 'US' )
                         ( City = 'Wolfsburg' CityShort = 'DE' )
                         ( City = 'Cologne' CityShort = 'DE' ) ).

    DATA(ld_all_entries) = lines( lt_values ).
    NEW zcl_bs_demo_adjust_data( )->adjust_via_request( EXPORTING io_request = io_request
                                                        CHANGING  ct_data    = lt_values ).

    IF io_request->is_data_requested( ).
      io_response->set_data( lt_values ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( CONV #( ld_all_entries ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
