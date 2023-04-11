CLASS zcl_eml_bo_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_eml_bo_test IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    GET TIME STAMP FIELD DATA(lv_time).

*    MODIFY ENTITY ZC_PurchaseHeaderDet_R19
*    CREATE FIELDS ( PoOrder PoDesc PoType CompCode PoOrg PurchaseStatus Supplier CreateBy CreatedDateTime  )
*    WITH VALUE #( ( %cid = 'Bo1'
*                     PoOrder = '0000001012'
*                     PoDesc  = 'EML with Items Created'
*                     PoType  = 'SO'
*                     CompCode = '200'
*                     PoOrg    = '20'
*                     PurchaseStatus = '01'
*                     Supplier = '00800'
*                     CreateBy = 'Maaz'
*                     CreatedDateTime = lv_time ) )
*    CREATE BY \_PoItems
*    FIELDS (  PoItem ShortText Material Plant MatGroup OrderQunt OrderUnit ProductPrice PriceUnit )
*    WITH VALUE #( ( PoOrder = '0000001012'
*                    %cid_ref = 'Bo1'
*                    %key = '0000001012'
*                    %target = VALUE #( ( %cid = 'BoI1'
*                                       PoItem = '00010'
*                                       ShortText = 'EML Item 1'
*                                       Material = 'TOUCH_PENS'
*                                       Plant = '1010'
*                                       MatGroup = '0002'
*                                       OrderQunt = 6
*                                       OrderUnit = 'EA'
*                                       ProductPrice = 140
*                                       PriceUnit = 'USD' ) ) ) )
*    REPORTED DATA(reported)
*    FAILED DATA(failed)
*    MAPPED DATA(mapped).

*    MODIFY ENTITY ZC_PurchaseHeaderDet_R19
*    CREATE BY \_PoItems
*    FIELDS ( ShortText Material Plant MatGroup OrderQunt OrderUnit ProductPrice PriceUnit )
*    WITH VALUE #( ( PoOrder = '0000001012'
*                    %key = '0000001012'
*                    %target = VALUE #( ( %cid = 'BoI2'
*                                       ShortText = 'EML Item 3'
*                                       Material = 'Mobile'
*                                       Plant = '1010'
*                                       MatGroup = '0002'
*                                       OrderQunt = 5
*                                       OrderUnit = 'EA'
*                                       ProductPrice = 1400
*                                       PriceUnit = 'USD' ) ) ) )
*
*    REPORTED DATA(reported)
*    FAILED DATA(failed)
*    MAPPED DATA(mapped).


*    MODIFY ENTITY ZI_PurchaseHeaderTP_UM_R19
*    DELETE FROM VALUE #( ( PoOrder = '1016' ) ) .
*
*    COMMIT ENTITIES.

    READ ENTITIES OF ZI_PurchaseHeaderTP_UM_R19
    ENTITY PurchaseHeader
*    BY \_PoItems
    ALL FIELDS WITH VALUE #( ( %key-PoOrder = '0000001017'  ) )
    RESULT DATA(lt_items).

    IF lt_items IS NOT INITIAL.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
