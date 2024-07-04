"! <p class="shorttext synchronized" lang="en">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>cds_zbs_demo_company_names</em>
CLASS zcl_bs_demo_rap_onprem_newv2 DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">CompanyNamesType</p>
      BEGIN OF tys_company_names_type,
        "! <em>Key property</em> CompanyName
        company_name        TYPE c LENGTH 60,
        "! Branch
        branch              TYPE c LENGTH 50,
        "! CompanyDescription
        company_description TYPE c LENGTH 255,
      END OF tys_company_names_type,
      "! <p class="shorttext synchronized" lang="en">List of CompanyNamesType</p>
      tyt_company_names_type TYPE STANDARD TABLE OF tys_company_names_type WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! CompanyNames
        "! <br/> Collection of type 'CompanyNamesType'
        company_names TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'COMPANY_NAMES',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
         "! Dummy field - Structure must not be empty
         dummy TYPE int1 VALUE 0,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized" lang="en">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized" lang="en">Define CompanyNamesType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_company_names_type RAISING /iwbep/cx_gateway.

ENDCLASS.



CLASS ZCL_BS_DEMO_RAP_ONPREM_NEWV2 IMPLEMENTATION.


  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'cds_zbs_demo_company_names' ).

    def_company_names_type( ).

  ENDMETHOD.


  METHOD def_company_names_type.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'COMPANY_NAMES_TYPE'
                                    is_structure              = VALUE tys_company_names_type( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'CompanyNamesType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'COMPANY_NAMES' ).
    lo_entity_set->set_edm_name( 'CompanyNames' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'COMPANY_NAME' ).
    lo_primitive_property->set_edm_name( 'CompanyName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 60 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BRANCH' ).
    lo_primitive_property->set_edm_name( 'Branch' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 50 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COMPANY_DESCRIPTION' ).
    lo_primitive_property->set_edm_name( 'CompanyDescription' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 255 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.
ENDCLASS.
