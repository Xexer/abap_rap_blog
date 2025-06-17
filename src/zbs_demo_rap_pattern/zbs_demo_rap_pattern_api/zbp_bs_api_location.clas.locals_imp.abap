CLASS lcl_buffer DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA new_entries TYPE TABLE FOR CREATE zbs_r_apilocation\\location.
ENDCLASS.


CLASS lhc_Location DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Location RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Location RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Location.

    METHODS read FOR READ
      IMPORTING keys FOR READ Location RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Location.

ENDCLASS.


CLASS lhc_Location IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD create.
    INSERT LINES OF entities INTO TABLE lcl_buffer=>new_entries.
  ENDMETHOD.


  METHOD read.
  ENDMETHOD.


  METHOD lock.
  ENDMETHOD.
ENDCLASS.


CLASS lsc_ZBS_R_APILOCATION DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS
      finalize REDEFINITION.

    METHODS
      check_before_save REDEFINITION.

    METHODS
      save REDEFINITION.

    METHODS
      cleanup REDEFINITION.

    METHODS
      cleanup_finalize REDEFINITION.

  PRIVATE SECTION.
    "! Check if the location id is correct (starting with L)
    "! @parameter location_id | Location id
    "! @parameter result | X = Valid, '' = Error
    METHODS is_location_id_valid
      IMPORTING location_id   TYPE zcl_bs_api_target=>location-location_id
      RETURNING VALUE(result) TYPE abap_boolean.
ENDCLASS.


CLASS lsc_ZBS_R_APILOCATION IMPLEMENTATION.
  METHOD finalize.
  ENDMETHOD.


  METHOD check_before_save.
    LOOP AT lcl_buffer=>new_entries INTO DATA(new).
      IF NOT is_location_id_valid( new-LocationId ).
        INSERT VALUE #( %key = new-%key ) INTO TABLE failed-location.
        INSERT VALUE #( %key = new-%key
                        %msg = new_message( id       = 'ZBS_DEMO_RAP_PATTERN'
                                            number   = '011'
                                            severity = if_abap_behv_message=>severity-error
                                            v1       = new-LocationId ) )
               INTO TABLE reported-location.
      ENDIF.

      IF new-LocalPeople <= 0.
        INSERT VALUE #( %key = new-%key ) INTO TABLE failed-location.
        INSERT VALUE #( %key = new-%key
                        %msg = new_message( id       = 'ZBS_DEMO_RAP_PATTERN'
                                            number   = '012'
                                            severity = if_abap_behv_message=>severity-error ) )
               INTO TABLE reported-location.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD save.
    DATA(new_database_entries) = CORRESPONDING zcl_bs_api_target=>locations( lcl_buffer=>new_entries MAPPING FROM ENTITY ).

    NEW zcl_bs_api_target( )->save_locations( new_database_entries ).
  ENDMETHOD.


  METHOD cleanup.
  ENDMETHOD.


  METHOD cleanup_finalize.
  ENDMETHOD.


  METHOD is_location_id_valid.
    RETURN xco_cp=>string( location_id )->starts_with( 'L' ).
  ENDMETHOD.
ENDCLASS.
