CLASS zcl_bs_api_target DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES location  TYPE zbs_api_target.
    TYPES locations TYPE SORTED TABLE OF location WITH UNIQUE KEY location_id.

    METHODS save_locations
      IMPORTING locations     TYPE locations
      RETURNING VALUE(result) TYPE abap_boolean.

  PRIVATE SECTION.
    METHODS is_availabe
      IMPORTING location_id   TYPE location-location_id
      RETURNING VALUE(result) TYPE abap_boolean.
ENDCLASS.



CLASS ZCL_BS_API_TARGET IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DELETE FROM zbs_api_target.
    COMMIT WORK.
  ENDMETHOD.


  METHOD is_availabe.
    SELECT SINGLE FROM zbs_api_target
      FIELDS location_id
      WHERE location_id = @location_id
      INTO @DATA(found_id).

    RETURN xsdbool( zcl_syst=>create( )->return_code( ) = 0 AND found_id IS NOT INITIAL ).
  ENDMETHOD.


  METHOD save_locations.
    result = abap_true.

    LOOP AT locations INTO DATA(location).
      IF is_availabe( location-location_id ).
        UPDATE zbs_api_target
          SET location_name = @location-location_name,
              location_coordinates   = @location-location_coordinates,
              local_people   = @location-local_people,
              changed_at   = @( zcl_syst=>create( )->utclong( ) )
          WHERE location_id = @location-location_id.
      ELSE.
        location-created_at = zcl_syst=>create( )->utclong( ).
        INSERT zbs_api_target FROM @location.
      ENDIF.

      IF zcl_syst=>create( )->return_code( ) <> 0.
        CLEAR result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
