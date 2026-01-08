CLASS zcl_bs_demo_rap_sales_fields DEFINITION
  PUBLIC
  INHERITING FROM cl_xco_cp_adt_simple_classrun FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS
      main REDEFINITION.
ENDCLASS.


CLASS zcl_bs_demo_rap_sales_fields IMPLEMENTATION.
  METHOD main.
    DATA(abstract_entities) = VALUE zif_gen_objects=>abstract_entities(
        ( name        = 'ZBS_S_SASale'
          description = 'Sale'
          fields      = VALUE #( ( name = 'PartnerNumber' data_element = 'PARTNER' )
                                 ( name = 'SalesDate' data_element = 'DATE' )
                                 ( name = 'SalesVolume' data_element = 'AMOUNT' currency = 'SalesCurrency' )
                                 ( name = 'SalesCurrency' data_element = 'CURRENCY' )
                                 ( name = 'DifferenceAmount' data_element = 'AMOUNT' currency = 'DifferenceCurrency' )
                                 ( name = 'DifferenceCurrency' data_element = 'CURRENCY' )
                                 ( name = 'DifferenceQuantity' data_element = 'QUANTITY' unit = 'DifferenceUnit' )
                                 ( name = 'DifferenceUnit' data_element = 'UNIT' )
                                 ( name = 'SaleComment' data_element = 'COMMENT' ) ) )
        ( name        = 'ZBS_S_SAInfo'
          description = 'Information'
          fields      = VALUE #( ( name = 'Language' data_element = zif_gen_objects=>special_types-language )
                                 ( name = 'Text' data_element = 'TEXT' ) ) )
        ( name        = 'ZBS_S_SASold'
          description = 'Sold'
          fields      = VALUE #( ( name = 'MaterialId' data_element = 'MATERIAL' ) ) )
        ( name        = 'ZBS_S_SASeller'
          description = 'Seller'
          fields      = VALUE #( ( name = 'SellerId' data_element = 'USER' )
                                 ( name = 'Quota' data_element = 'QUOTA' )
                                 ( name = 'Confirmed' data_element = zif_gen_objects=>special_types-boolean ) ) ) ).

    DATA(data_elements) = VALUE zif_gen_objects=>data_elements(
        ( name = 'PARTNER' domain = 'PARTNER' description = 'Partner ID' )
        ( name = 'DATE' domain = 'DATE' description = 'Sale Date' )
        ( name = 'AMOUNT' domain = 'AMOUNT' description = 'Amount' )
        ( name = 'CURRENCY' domain = 'CURRENCY' description = 'Currency' )
        ( name = 'QUANTITY' domain = 'QUANTITY' description = 'Quantity' )
        ( name = 'UNIT' domain = 'UNIT' description = 'Unit' )
        ( name = 'COMMENT' domain = 'COMMENT' description = 'Comment' )
        ( name = 'TEXT' domain = 'TEXT' description = 'Text' )
        ( name = 'MATERIAL' domain = 'MATERIAL' description = 'Material ID' )
        ( name = 'USER' domain = 'USER' description = 'User ID' )
        ( name = 'QUOTA' domain = 'QUOTA' description = 'Quota' ) ).

    DATA(domains) = VALUE zif_gen_objects=>domains(
        ( name = 'PARTNER' base_type = zif_gen_objects=>domain_types-character length = 10 )
        ( name = 'DATE' base_type = zif_gen_objects=>domain_types-date )
        ( name = 'AMOUNT' base_type = zif_gen_objects=>domain_types-currency )
        ( name = 'CURRENCY' base_type = zif_gen_objects=>domain_types-currency_code )
        ( name = 'QUANTITY' base_type = zif_gen_objects=>domain_types-quantity length = 10 decimals = 2 )
        ( name = 'UNIT' base_type = zif_gen_objects=>domain_types-unit )
        ( name = 'COMMENT' base_type = zif_gen_objects=>domain_types-string )
        ( name = 'TEXT' base_type = zif_gen_objects=>domain_types-character length = 160 case_sensitive = abap_true )
        ( name = 'MATERIAL' base_type = zif_gen_objects=>domain_types-character length = 5 )
        ( name = 'USER' base_type = zif_gen_objects=>domain_types-character length = 12 )
        ( name = 'QUOTA' base_type = zif_gen_objects=>domain_types-decimals length = 5 decimals = 2 ) ).

    DATA(config) = VALUE zif_gen_objects=>ddic_configuration( prefix            = 'ZBS_DEMO_SA_'
                                                              domains           = domains
                                                              data_elements     = data_elements
                                                              abstract_entities = abstract_entities ).

    DATA(generator) = zcl_gen_objects_factory=>create_generator( sy-repid ).
    DATA(result) = generator->generate_ddic( config ).
    out->write( result->findings ).
  ENDMETHOD.
ENDCLASS.
