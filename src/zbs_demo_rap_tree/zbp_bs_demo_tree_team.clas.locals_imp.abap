CLASS lhc_zbs_r_dmotreeteam DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
              IMPORTING
                 REQUEST requested_authorizations FOR Team
              RESULT result.
ENDCLASS.


CLASS lhc_zbs_r_dmotreeteam IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
ENDCLASS.


CLASS lsc_zbs_r_dmotreeteam DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS
      save_modified REDEFINITION.

  PRIVATE SECTION.
    TYPES node  TYPE ZBS_I_DMOTreeTeamHR.
    TYPES nodes TYPE SORTED TABLE OF node WITH UNIQUE KEY UserId.

    METHODS delete_entries
      IMPORTING user_id TYPE ZBS_I_DMOTreeTeamHR-UserId.

    METHODS move_entries
      IMPORTING user_id TYPE ZBS_I_DMOTreeTeamHR-UserId.

    METHODS get_subnodes
      IMPORTING user_id       TYPE ZBS_I_DMOTreeTeamHR-UserId
                recursive     TYPE abap_boolean
      RETURNING VALUE(result) TYPE nodes.
ENDCLASS.


CLASS lsc_zbs_r_dmotreeteam IMPLEMENTATION.
  METHOD save_modified.
    LOOP AT delete-team INTO DATA(member).
*      delete_entries( member-UserId ).
      move_entries( member-UserId ).
    ENDLOOP.
  ENDMETHOD.


  METHOD get_subnodes.
    SELECT FROM ZBS_I_DMOTreeTeamHR
      FIELDS *
      WHERE TeamLeader = @user_id
      INTO TABLE @DATA(subnodes).

    LOOP AT subnodes INTO DATA(subnode).
      INSERT subnode INTO TABLE result.

      IF recursive = abap_true.
        INSERT LINES OF get_subnodes( user_id   = subnode-UserId
                                      recursive = recursive ) INTO TABLE result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD delete_entries.
    DATA(subnodes) = get_subnodes( user_id   = user_id
                                   recursive = abap_true ).

    LOOP AT subnodes INTO DATA(subnode).
      DELETE FROM zbs_dmo_team WHERE user_id = @subnode-UserId.
    ENDLOOP.
  ENDMETHOD.


  METHOD move_entries.
    DATA(subnodes) = get_subnodes( user_id   = user_id
                                   recursive = abap_false ).

    LOOP AT subnodes INTO DATA(subnode).
      UPDATE zbs_dmo_team SET team_leader = 'P0000' WHERE user_id = @subnode-UserId.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
