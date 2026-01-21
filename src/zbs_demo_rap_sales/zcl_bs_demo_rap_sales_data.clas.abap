CLASS zcl_bs_demo_rap_sales_data DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS cleanup_old_data.

    METHODS create_and_insert_new_data
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.


CLASS zcl_bs_demo_rap_sales_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    cleanup_old_data( ).
    create_and_insert_new_data( out ).
  ENDMETHOD.


  METHOD cleanup_old_data.
    DELETE FROM zbs_sasale.
    DELETE FROM zbs_sasale_d.
    DELETE FROM zbs_sainfo.
    DELETE FROM zbs_sainfo_d.
    DELETE FROM zbs_saseller.
    DELETE FROM zbs_saseller_d.
    DELETE FROM zbs_sasold.
    DELETE FROM zbs_sasold_d.
    COMMIT WORK.
  ENDMETHOD.


  METHOD create_and_insert_new_data.
    DATA sales   TYPE TABLE FOR CREATE zbs_r_sasale.
    DATA infos   TYPE TABLE FOR CREATE zbs_r_sasale\_SAInfo.
    DATA sellers TYPE TABLE FOR CREATE zbs_r_sasale\_SASeller.
    DATA solds   TYPE TABLE FOR CREATE zbs_r_sasale\_SASold.

    DATA(actual_user) = sy-uname.
    DATA(id_sap_sale) = '100000000020260101'.
    DATA(id_meta_sale) = '100000000220260105'.
    DATA(id_nestle_sale) = '100000000520260105'.

    sales = VALUE #( ( %cid               = id_sap_sale
                       PartnerNumber      = '1000000000'
                       SalesDate          = '20260101'
                       SalesVolume        = '23000'
                       SalesCurrency      = 'EUR'
                       SaleComment        = `New year, new sales`
                       DifferenceAmount   = '15000'
                       DifferenceCurrency = 'EUR' )
                     ( %cid               = id_meta_sale
                       PartnerNumber      = '1000000002'
                       SalesDate          = '20260105'
                       SalesVolume        = '65500'
                       SalesCurrency      = 'USD'
                       SaleComment        = `VR stuff and More`
                       DifferenceAmount   = '1000'
                       DifferenceCurrency = 'USD' )
                     ( %cid          = id_nestle_sale
                       PartnerNumber = '1000000005'
                       SalesDate     = '20260105'
                       SalesVolume   = '99999'
                       SalesCurrency = 'CHF'
                       SaleComment   = `Activation of more Cloud volume` )
                     ( %cid          = xco_cp=>uuid( )->value
                       PartnerNumber = '1000000000'
                       SalesDate     = '20251217'
                       SalesVolume   = '26000'
                       SalesCurrency = 'EUR' )
                     ( %cid          = xco_cp=>uuid( )->value
                       PartnerNumber = '1000000005'
                       SalesDate     = '20251218'
                       SalesVolume   = '2000'
                       SalesCurrency = 'USD' )
                     ( %cid          = xco_cp=>uuid( )->value
                       PartnerNumber = '1000000005'
                       SalesDate     = '20251110'
                       SalesVolume   = '63000'
                       SalesCurrency = 'USD' )
                     ( %cid          = xco_cp=>uuid( )->value
                       PartnerNumber = '1000000002'
                       SalesDate     = '20251111'
                       SalesVolume   = '66000'
                       SalesCurrency = 'EUR' )
                     ( %cid          = xco_cp=>uuid( )->value
                       PartnerNumber = '1000000000'
                       SalesDate     = '20251026'
                       SalesVolume   = '9900'
                       SalesCurrency = 'CHF' )
                     ( %cid          = xco_cp=>uuid( )->value
                       PartnerNumber = '1000000005'
                       SalesDate     = '20260213'
                       SalesVolume   = '6800'
                       SalesCurrency = 'CHF' )
                     ( %cid          = xco_cp=>uuid( )->value
                       PartnerNumber = '1000000002'
                       SalesDate     = '20241231'
                       SalesVolume   = '9500'
                       SalesCurrency = 'EUR' )
                     ( %cid          = xco_cp=>uuid( )->value
                       PartnerNumber = '1000000000'
                       SalesDate     = '20250606'
                       SalesVolume   = '71500'
                       SalesCurrency = 'USD' )
                     ( %cid          = xco_cp=>uuid( )->value
                       PartnerNumber = '1000000005'
                       SalesDate     = '20260219'
                       SalesVolume   = '58000'
                       SalesCurrency = 'USD' )
                     ( %cid          = xco_cp=>uuid( )->value
                       PartnerNumber = '1000000000'
                       SalesDate     = '20260319'
                       SalesVolume   = '17000'
                       SalesCurrency = 'EUR' )
                     ( %cid          = xco_cp=>uuid( )->value
                       PartnerNumber = '1000000002'
                       SalesDate     = '20251201'
                       SalesVolume   = '95000'
                       SalesCurrency = 'CHF' ) ).

    infos = VALUE #(

        ( %cid_ref = id_sap_sale
          %target  = VALUE #(
              ( Language = 'D' TextInformation = 'Bitte noch einmal zum Abschluss prüfen' )
              ( Language = 'E' TextInformation = 'Please check one last time before finalizing the check.' )
              ( Language = 'F' TextInformation = 'Veuillez vérifier une dernière fois avant de finaliser le chèque.' )
              ( Language = 'I' TextInformation = `Si prega di controllare un'ultima volta prima di finalizzare il controllo.` ) ) )
        ( %cid_ref = id_nestle_sale
          %target  = VALUE #( ( Language = 'D' TextInformation = 'Vertragsprüfung ausstehend' )
                              ( Language = 'E' TextInformation = 'Contract review pending' )
                              ( Language = 'F' TextInformation = 'Examen du contrat en cours' )
                              ( Language = 'I' TextInformation = `Revisione del contratto in sospeso` ) ) ) ).

    sellers = VALUE #( ( %cid_ref = id_sap_sale
                         %target  = VALUE #( ( SellerId = actual_user Quota = '80' Confirmed = abap_true )
                                             ( SellerId = 'SELLER1' Quota = '10' Confirmed = abap_false )
                                             ( SellerId = 'SELLER2' Quota = '10' Confirmed = abap_false ) ) )
                       ( %cid_ref = id_meta_sale
                         %target  = VALUE #( ( SellerId = actual_user Quota = '100' Confirmed = abap_false ) ) ) ).

    solds = VALUE #( ( %cid_ref = id_sap_sale
                       %target  = VALUE #( ( MaterialId = 'F0002' ) ) )
                     ( %cid_ref = id_nestle_sale
                       %target  = VALUE #( ( MaterialId = 'H0001' )
                                           ( MaterialId = 'H0002' ) ) ) ).

    MODIFY ENTITIES OF zbs_r_sasale
           ENTITY SASale
           CREATE FIELDS ( PartnerNumber SalesDate SalesVolume SalesCurrency SaleComment DifferenceAmount DifferenceCurrency )
           WITH sales

           ENTITY SASale
           CREATE BY \_SAInfo AUTO FILL CID FIELDS ( Language TextInformation )
           WITH infos

           ENTITY SASale
           CREATE BY \_SASeller AUTO FILL CID FIELDS ( SellerId Quota Confirmed )
           WITH sellers

           ENTITY SASale
           CREATE BY \_SASold AUTO FILL CID FIELDS ( MaterialId )
           WITH solds

           FAILED DATA(failed)
           MAPPED DATA(mapped)
           REPORTED DATA(reported).

    COMMIT ENTITIES.

    out->write( failed-sasale ).
    out->write( mapped-sasale ).
    out->write( reported-sasale ).
  ENDMETHOD.
ENDCLASS.
