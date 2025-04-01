CLASS zcl_bs_demo_service_prov_fact DEFINITION
  PUBLIC ABSTRACT FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS create_service_provider
      IMPORTING configuration TYPE zif_bs_demo_service_prov=>configuration
      RETURNING VALUE(result) TYPE REF TO zif_bs_demo_service_prov.
ENDCLASS.


CLASS zcl_bs_demo_service_prov_fact IMPLEMENTATION.
  METHOD create_service_provider.
    RETURN NEW zcl_bs_demo_service_prov( configuration ).
  ENDMETHOD.
ENDCLASS.
