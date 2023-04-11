CLASS lhc_PurchaseHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR PurchaseHeader RESULT result.

    METHODS copy FOR MODIFY
      IMPORTING keys FOR ACTION purchaseheader~copy RESULT result.

    METHODS withdrawstatus FOR MODIFY
      IMPORTING keys FOR ACTION purchaseheader~withdrawstatus RESULT result.

    METHODS checkstatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR purchaseheader~checkstatus.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE purchaseheader.

    METHODS earlynumbering_cba_poitems FOR NUMBERING
      IMPORTING entities FOR CREATE purchaseheader\_poitems.

ENDCLASS.

CLASS lhc_PurchaseHeader IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    IF entities IS NOT INITIAL.
      SELECT MAX( PoOrder )
      FROM ZC_PurchaseHeaderDet_R19
      INTO @DATA(lv_max_po).
      IF sy-subrc IS INITIAL.
        lv_max_po = lv_max_po + 1.
        mapped-purchaseheader = VALUE #( FOR lwa_en IN entities ( %cid = lwa_en-%cid
                                                                  %is_draft = lwa_en-%is_draft
                                                                  %key-PoOrder = |{ lv_max_po ALPHA = IN }|
                                                                  PoOrder = |{ lv_max_po ALPHA = IN }| ) ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD earlynumbering_cba_Poitems.

    IF entities IS NOT INITIAL.

      DATA(lwa_poorder) = VALUE #( entities[ 1 ] OPTIONAL ).
      DATA lv_poitem TYPE ebelp.
      IF lwa_poorder-%is_draft = 01.

        READ ENTITIES OF ZC_PurchaseHeaderDet_R19 IN LOCAL MODE
        ENTITY PurchaseHeader
        FIELDS ( PoOrder )
        WITH CORRESPONDING #( entities )
        RESULT DATA(lt_header).

*      SELECT SINGLE @abap_true
*       FROM ZC_PurchaseItemDet_R19
*       WHERE PoOrder = @lwa_poorder-PoOrder
*       INTO @DATA(lv_exist).
        IF lt_header IS  NOT INITIAL.

          READ ENTITY IN LOCAL MODE ZC_PurchaseHeaderDet_R19
          BY \_PoItems
          FIELDS ( PoOrder PoItem )
          WITH CORRESPONDING #( entities )
          RESULT DATA(lt_item).

*      READ ENTITIES OF ZC_PurchaseHeaderDet_R19 IN LOCAL MODE
*      ENTITY PurchaseItem
*      FIELDS ( PoOrder PoItem )
*      WITH CORRESPONDING #( entities )
*      RESULT DATA(lt_item).

*        SELECT MAX( PoItem )
*        FROM ZC_PurchaseItemDet_R19
*        WHERE PoOrder = @lwa_poorder-PoOrder
*        INTO @DATA(lv_poitem).
          IF lt_item IS NOT INITIAL.

            DATA(lwa_item) = VALUE #( lt_item[ lines( lt_item ) ]  OPTIONAL ).
            LOOP AT entities INTO DATA(lwa_entities).
              lv_poitem = lwa_item-PoItem + 10.
              APPEND VALUE #( %cid = VALUE #( lwa_entities-%target[ 1 ]-%cid OPTIONAL )
                              %tky = lwa_entities-%tky
                              PoOrder = lwa_entities-PoOrder
                              PoItem = lv_poitem ) TO mapped-purchaseitem.
            ENDLOOP.
          ELSE.
*          lwa_item = VALUE #( lt_item[ lines( lt_item ) ] OPTIONAL ).
            LOOP AT entities INTO lwa_entities.
              lv_poitem = 10.
              APPEND VALUE #( %cid = VALUE #( lwa_entities-%target[ 1 ]-%cid OPTIONAL )
                              %tky = lwa_entities-%tky
                              PoOrder = lwa_entities-PoOrder
                              PoItem = lv_poitem ) TO mapped-purchaseitem.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ELSE.
        LOOP AT lwa_poorder-%target INTO DATA(lwa_po).
          APPEND VALUE #(   %cid = lwa_po-%cid
                            %tky = lwa_poorder-%tky
                            PoOrder = lwa_po-PoOrder
                            PoItem  =  lwa_po-PoItem ) TO mapped-purchaseitem.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD Copy.

    DATA lt_keys TYPE TABLE FOR READ IMPORT ZC_PurchaseHeaderDet_R19.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    LOOP AT keys INTO DATA(lwa_keys).
      APPEND VALUE #( %key = lwa_keys-%key
                      %control-PoDesc = 01
                      %control-PoType = 01
                      %control-CompCode = 01
                      %control-PoOrg = 01
                      %control-Supplier = 01 ) TO lt_keys.
    ENDLOOP.

    "Read the BDEF.

    READ ENTITIES OF ZC_PurchaseHeaderDet_R19 IN LOCAL MODE
    ENTITY PurchaseHeader
    FROM CORRESPONDING #( lt_keys )
    RESULT DATA(lt_po_data).

    LOOP AT lt_po_data ASSIGNING FIELD-SYMBOL(<fs_po>).
      <fs_po>-CreatedDateTime = lv_timestamp.
      <fs_po>-PurchaseStatus = '01'.
    ENDLOOP.

    "Create new record.

    MODIFY ENTITIES OF ZC_PurchaseHeaderDet_R19 IN LOCAL MODE
    ENTITY PurchaseHeader
    CREATE AUTO FILL CID FIELDS ( PoDesc PoType CompCode PoOrg Supplier CreatedDateTime PurchaseStatus PurchaseTotalPrice Imageurl )
    WITH CORRESPONDING #( lt_po_data )
    MAPPED mapped.

*    MODIFY ENTITIES OF ZC_PurchaseHeaderDet_R19 IN LOCAL MODE
*    ENTITY PurchaseHeader
*    UPDATE FIELDS ( CompCode )
*    WITH VALUE #( ( PoOrder = '11' CompCode = '200' ) )
*    MAPPED mapped.
    "Return the result set.
    READ ENTITIES OF ZC_PurchaseHeaderDet_R19 IN LOCAL MODE
    ENTITY PurchaseHeader
    FROM CORRESPONDING #( mapped-purchaseheader )
    RESULT DATA(lt_npo_data).

    result = VALUE #( FOR ls_npo IN lt_npo_data INDEX INTO i (
                      %key = keys[ i ]-%key
                      %cid_ref = keys[ i ]-%cid_ref
                      %param = CORRESPONDING #( ls_npo ) ) ).

  ENDMETHOD.

  METHOD WithdrawStatus.
  ENDMETHOD.

  METHOD checkstatus.

    DATA : lt_po  TYPE TABLE FOR READ RESULT ZC_PurchaseHeaderDet_R19,
           ls_po  LIKE LINE OF lt_po,
           ob_ref TYPE REF TO cl_abap_behv.

    CREATE OBJECT ob_ref.

    IF keys IS NOT INITIAL.

      READ ENTITIES OF ZC_PurchaseHeaderDet_R19 IN LOCAL MODE
      ENTITY PurchaseHeader
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT lt_po.

      ls_po = VALUE #( lt_po[ 1 ] OPTIONAL ).
      IF ls_po IS NOT INITIAL.
        SELECT SINGLE @abap_true
        FROM zc_purchasestatus_r19
        WHERE Postatus = @ls_po-PurchaseStatus
        INTO @DATA(lv_exist).
        IF lv_exist IS INITIAL.
          APPEND VALUE #( %tky = ls_po-%tky  ) TO failed-purchaseheader.
          APPEND VALUE #( %tky = ls_po-%tky
                          %msg = ob_ref->new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = 'Please Check Purchase Status'
                                 )
                         %element-purchasestatus =  if_abap_behv=>mk-on
                           ) TO reported-purchaseheader.
        ENDIF.
      ENDIF.

    ENDIF.
  ENDMETHOD.

ENDCLASS.
