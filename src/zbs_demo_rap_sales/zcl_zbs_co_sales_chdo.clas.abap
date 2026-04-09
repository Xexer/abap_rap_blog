CLASS zcl_zbs_co_sales_chdo DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_chdo_enhancements.

    CLASS-DATA objectclass TYPE if_chdo_object_tools_rel=>ty_cdobjectcl READ-ONLY VALUE 'ZBS_CO_SALES' ##NO_TEXT.

    CLASS-METHODS write
      IMPORTING objectid                TYPE if_chdo_object_tools_rel=>ty_cdobjectv
                utime                   TYPE if_chdo_object_tools_rel=>ty_cduzeit
                udate                   TYPE if_chdo_object_tools_rel=>ty_cddatum
                username                TYPE if_chdo_object_tools_rel=>ty_cdusername
                planned_change_number   TYPE if_chdo_object_tools_rel=>ty_planchngnr DEFAULT space
                object_change_indicator TYPE if_chdo_object_tools_rel=>ty_cdchngindh DEFAULT 'U'
                planned_or_real_changes TYPE if_chdo_object_tools_rel=>ty_cdflag     DEFAULT space
                no_change_pointers      TYPE if_chdo_object_tools_rel=>ty_cdflag     DEFAULT space
                o_zbs_sasale            TYPE zbs_sasale                              OPTIONAL
                n_zbs_sasale            TYPE zbs_sasale                              OPTIONAL
                upd_zbs_sasale          TYPE if_chdo_object_tools_rel=>ty_cdchngindh DEFAULT space
                o_zbs_saseller          TYPE zbs_saseller                            OPTIONAL
                n_zbs_saseller          TYPE zbs_saseller                            OPTIONAL
                upd_zbs_saseller        TYPE if_chdo_object_tools_rel=>ty_cdchngindh DEFAULT space
      EXPORTING VALUE(changenumber)     TYPE if_chdo_object_tools_rel=>ty_cdchangenr
      RAISING   cx_chdo_write_error.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_zbs_co_sales_chdo IMPLEMENTATION.
  METHOD write.
*"----------------------------------------------------------------------
*"         this WRITE method is generated for object ZBS_CO_SALES
*"         never change it manually, please!        :04/08/2026
*"         All changes will be overwritten without a warning!
*"
*"         CX_CHDO_WRITE_ERROR is used for error handling
*"----------------------------------------------------------------------

    DATA l_upd TYPE if_chdo_object_tools_rel=>ty_cdchngind.

    cl_chdo_write_tools=>changedocument_open( objectclass             = objectclass
                                              objectid                = objectid
                                              planned_change_number   = planned_change_number
                                              planned_or_real_changes = planned_or_real_changes ).

    IF     ( n_zbs_sasale IS INITIAL )
       AND ( o_zbs_sasale IS INITIAL ).
      l_upd = space.
    ELSE.
      l_upd = upd_zbs_sasale.
    ENDIF.

    IF l_upd <> space.
      cl_chdo_write_tools=>changedocument_single_case( tablename        = 'ZBS_SASALE'
                                                       workarea_old     = o_zbs_sasale
                                                       workarea_new     = n_zbs_sasale
                                                       change_indicator = upd_zbs_sasale
                                                       docu_delete      = 'X'
                                                       docu_insert      = 'X'
                                                       docu_delete_if   = ''
                                                       docu_insert_if   = '' ).
    ENDIF.

    IF     ( n_zbs_saseller IS INITIAL )
       AND ( o_zbs_saseller IS INITIAL ).
      l_upd = space.
    ELSE.
      l_upd = upd_zbs_saseller.
    ENDIF.

    IF l_upd <> space.
      cl_chdo_write_tools=>changedocument_single_case( tablename        = 'ZBS_SASELLER'
                                                       workarea_old     = o_zbs_saseller
                                                       workarea_new     = n_zbs_saseller
                                                       change_indicator = upd_zbs_saseller
                                                       docu_delete      = 'X'
                                                       docu_insert      = 'X'
                                                       docu_delete_if   = ''
                                                       docu_insert_if   = '' ).
    ENDIF.

    cl_chdo_write_tools=>changedocument_close( EXPORTING objectclass             = objectclass
                                                         objectid                = objectid
                                                         date_of_change          = udate
                                                         time_of_change          = utime
                                                         username                = username
                                                         object_change_indicator = object_change_indicator
                                                         no_change_pointers      = no_change_pointers
                                               IMPORTING changenumber            = changenumber ).
  ENDMETHOD.


  METHOD if_chdo_enhancements~authority_check.
    rv_is_authorized = abap_true.
  ENDMETHOD.
ENDCLASS.
