/********** GENERATED on 01/09/2023 at 20:33:39 by CB9980000024**************/
 @OData.entitySet.name: 'CompanyNames' 
 @OData.entityType.name: 'CompanyNamesType' 
 define root abstract entity ZBS_RAP_COMPANYNAMES { 
 key CompanyName : abap.char( 60 ) ; 
 @Odata.property.valueControl: 'Branch_vc' 
 Branch : abap.char( 50 ) ; 
 Branch_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 @Odata.property.valueControl: 'CompanyDescription_vc' 
 CompanyDescription : abap.char( 255 ) ; 
 CompanyDescription_vc : RAP_CP_ODATA_VALUE_CONTROL ; 
 
 } 
