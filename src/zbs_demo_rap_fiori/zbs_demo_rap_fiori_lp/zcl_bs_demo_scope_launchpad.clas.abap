CLASS zcl_bs_demo_scope_launchpad DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    TYPES object_name TYPE c LENGTH 40.
    TYPES objects     TYPE STANDARD TABLE OF object_name WITH EMPTY KEY.

    DATA scope_state TYPE c LENGTH 1 VALUE if_aps_bc_scope_change_api=>gc_scope_state-on.

    METHODS scope_content
      IMPORTING !pages TYPE objects
                spaces TYPE objects
                !out   TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS ZCL_BS_DEMO_SCOPE_LAUNCHPAD IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    scope_content( pages  = VALUE #( ( 'ZBS_DEMO_ADT_PAGE' ) )
                   spaces = VALUE #( ( 'ZBS_DEMO_ADT_SPACE' ) )
                   out    = out ).
  ENDMETHOD.


  METHOD scope_content.
    DATA scopes TYPE if_aps_bc_scope_change_api=>tt_object_scope_sorted.

    DATA(scope_api) = cl_aps_bc_scope_change_api=>create_instance( ).

    LOOP AT spaces INTO DATA(new_space).
      INSERT VALUE #( pgmid       = if_aps_bc_scope_change_api=>gc_tadir_pgmid-r3tr
                      scope_state = scope_state
                      object      = if_aps_bc_scope_change_api=>gc_tadir_object-uist
                      obj_name    = new_space ) INTO TABLE scopes.
    ENDLOOP.

    LOOP AT pages INTO DATA(new_page).
      INSERT VALUE #( pgmid       = if_aps_bc_scope_change_api=>gc_tadir_pgmid-r3tr
                      scope_state = scope_state
                      object      = if_aps_bc_scope_change_api=>gc_tadir_object-uipg
                      obj_name    = new_page ) INTO TABLE scopes.
    ENDLOOP.

    scope_api->scope( EXPORTING it_object_scope  = scopes
                                iv_simulate      = abap_false
                                iv_force         = abap_false
                      IMPORTING et_object_result = DATA(results)
                                et_message       = DATA(messages) ).

    out->write( results ).
    out->write( messages ).
  ENDMETHOD.
ENDCLASS.
