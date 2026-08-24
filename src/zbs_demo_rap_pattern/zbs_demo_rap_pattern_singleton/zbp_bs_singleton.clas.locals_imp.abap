CLASS lsc_zbs_r_sinentitytp DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS
      save_modified REDEFINITION.

ENDCLASS.


CLASS lsc_zbs_r_sinentitytp IMPLEMENTATION.
  METHOD save_modified.
    LOOP AT update-singleton INTO DATA(new_dataset).
      DATA(number_participants) = 0.
      LOOP AT create-participant TRANSPORTING NO FIELDS WHERE NavigationKey = new_dataset-NavigationKey.
        number_participants += 1.
      ENDLOOP.

      INSERT zbs_sin_result FROM @( VALUE #( uuid                   = xco_cp=>uuid( )->value
                                             created_by             = new_dataset-NavigationKey
                                             created_at             = utclong_current( )
                                             user_name              = new_dataset-UserName
                                             random_id              = new_dataset-RandomId
                                             number_of_participants = number_participants ) ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_Singleton DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Singleton RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Singleton RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      keys REQUEST requested_features FOR Singleton RESULT result.
ENDCLASS.


CLASS lhc_Singleton IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD get_instance_features.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_participant DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS FillUserID FOR DETERMINE ON MODIFY
       keys FOR Participant~FillUserID.

ENDCLASS.


CLASS lhc_participant IMPLEMENTATION.
  METHOD FillUserID.
    MODIFY ENTITIES OF ZBS_R_SinEntityTP IN LOCAL MODE
           ENTITY Participant
           UPDATE FROM VALUE #( FOR key IN keys
                                ( %tky            = key-%tky
                                  UserID          = sy-uname
                                  %control-UserID = if_abap_behv=>mk-on ) ).
  ENDMETHOD.
ENDCLASS.
