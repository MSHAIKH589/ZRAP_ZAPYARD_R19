CLASS lhc_helper DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF gty_buffer,
             instance TYPE ZI_PurchaseHeaderTP_UM_R19,
             cid      TYPE string,
             pid      TYPE abp_behv_pid,
             changed  TYPE abap_bool,
             deleted  TYPE abap_bool,
           END OF gty_buffer,
           BEGIN OF gty_child_buffer,
             instance TYPE ZI_PurchaseItemTP_UM_R19,
             poorder  TYPE ebeln,
             cid      TYPE string,
             pid      TYPE abp_behv_pid,
             changed  TYPE abap_bool,
             deleted  TYPE abap_bool,
           END OF gty_child_buffer.
    CLASS-DATA : gwa_transfer TYPE STANDARD TABLE OF zpoheader_db_r19,
                 gwa_update   TYPE STANDARD TABLE OF zpoheader_db_r19,
                 gwa_item     TYPE zpoitems_db_r19,
                 gv_poorder   TYPE ebeln,
                 root_buffer  TYPE STANDARD TABLE OF gty_buffer WITH EMPTY KEY,
                 root_child   TYPE STANDARD TABLE OF gty_child_buffer WITH EMPTY KEY.
ENDCLASS.
CLASS lhc_helper IMPLEMENTATION.
ENDCLASS.
CLASS lhc_PurchaseHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    DATA : lv_maxpo TYPE ebeln.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR PurchaseHeader RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE PurchaseHeader.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE PurchaseHeader.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE PurchaseHeader.

    METHODS read FOR READ
      IMPORTING keys FOR READ PurchaseHeader RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK PurchaseHeader.

    METHODS rba_Poitems FOR READ
      IMPORTING keys_rba FOR READ PurchaseHeader\_Poitems FULL result_requested RESULT result LINK association_links.

    METHODS cba_Poitems FOR MODIFY
      IMPORTING entities_cba FOR CREATE PurchaseHeader\_Poitems.

ENDCLASS.

CLASS lhc_PurchaseHeader IMPLEMENTATION.

  METHOD get_instance_authorizations.
*    LOOP AT keys INTO DATA(lwa_keys).
*      IF lwa_keys-%key-PoOrder = '0000001017'.
*        APPEND VALUE #(
*            poorder = lwa_keys-%key-PoOrder
*            %update = if_abap_behv=>auth-unauthorized
*        ) TO result.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.

  METHOD create.
    DATA(lwa_entities) = VALUE #( entities[ 1 ] ).
    IF entities IS NOT INITIAL.
      lhc_helper=>gwa_transfer = CORRESPONDING #( entities MAPPING FROM ENTITY ).

      " Implement Late Numbering
      DATA(system_uuid) = cl_uuid_factory=>create_system_uuid( ).
      IF system_uuid IS BOUND.
        TRY.
            DATA(uuid_x16) = system_uuid->create_uuid_x16( ).
          CATCH  cx_uuid_error.
        ENDTRY.
      ENDIF.

      "Insertting values into unmanaged transactional buffer
      APPEND VALUE #(
      instance-PoOrder = lwa_entities-PoOrder
      cid              = lwa_entities-%cid
      pid              = uuid_x16
      changed          = abap_true
      deleted          = abap_false
      ) TO lhc_helper=>root_buffer.

      GET TIME STAMP FIELD DATA(lv_datetime).
      MODIFY lhc_helper=>gwa_transfer FROM
             VALUE zpoheader_db_r19(
*                                     po_order = lv_maxpo
                                     create_by = cl_abap_context_info=>get_user_technical_name(  )
                                     created_date_time = lv_datetime ) INDEX 1 TRANSPORTING create_by created_date_time .
      "When we are using late numbering we should append values to MAPPED parameter of Create to send %PID.
      APPEND VALUE #(
      %pid = uuid_x16
      %cid = lwa_entities-%cid
      %key = lwa_entities-%key
      ) TO mapped-purchaseheader.

    ENDIF.
  ENDMETHOD.

  METHOD update.
    IF entities IS NOT INITIAL.
      lhc_helper=>gwa_update = CORRESPONDING #( entities MAPPING FROM ENTITY ).
    ENDIF.
  ENDMETHOD.

  METHOD delete.
    IF keys IS NOT INITIAL.
      lhc_helper=>gv_poorder = VALUE #( keys[ 1 ]-PoOrder ).
    ENDIF.
  ENDMETHOD.

  METHOD read.
    IF keys IS NOT INITIAL.
      DATA(lv_poorder) = VALUE #( keys[ 1 ]-%key-PoOrder OPTIONAL ).

      READ ENTITIES OF ZI_PurchaseHeaderTP_UM_R19 IN LOCAL MODE
      ENTITY PurchaseHeader
      BY \_PoItems
      ALL FIELDS WITH VALUE #( ( %key = keys[ 1 ]-%key  ) )
      RESULT DATA(lt_items).
      IF lt_items IS NOT INITIAL.

        DATA(lv_sum) = REDUCE i( INIT count = 0
                                 FOR lwa_value IN lt_items
                                 NEXT count += lwa_value-ItemPrice ).

        SELECT * FROM
          ZC_PurchaseHeaderTP_UM_R19
          WHERE PoOrder = @lv_poorder
          INTO TABLE @DATA(lt_header).

        DATA(lv_total_val) = VALUE #( lt_header[ 1 ]-PurchaseTotalPrice OPTIONAL ).
        IF  lv_total_val = lv_sum.
          RETURN.
        ELSE.
            LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<fs_header>).
                <fs_header>-PurchaseTotalPrice = lv_sum.
            ENDLOOP.
        ENDIF.

        result = CORRESPONDING #( lt_header ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Poitems.
    IF keys_rba IS NOT INITIAL.
      DATA(lv_poorder) = VALUE #( keys_rba[ 1 ]-%key-PoOrder OPTIONAL ).

      SELECT * FROM
        ZC_PurchaseItemTP_UM_R19
        WHERE PoOrder = @lv_poorder
        INTO TABLE @DATA(lt_items).
      IF sy-subrc = 0.
        result = CORRESPONDING #( lt_items ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD cba_Poitems.
    IF entities_cba IS NOT INITIAL.
      " Implement Late Numbering
      DATA(system_uuid) = cl_uuid_factory=>create_system_uuid( ).
      IF system_uuid IS BOUND.
        TRY.
            DATA(uuid_x16) = system_uuid->create_uuid_x16( ).
          CATCH  cx_uuid_error.
        ENDTRY.
      ENDIF.

      DATA(lwa_entities_cba) = VALUE #( entities_cba[ 1 ] ).

      LOOP AT lwa_entities_cba-%target ASSIGNING FIELD-SYMBOL(<fs_target>).
        <fs_target>-PoOrder = lwa_entities_cba-PoOrder.
*        IF <fs_target>-PriceUnit <> 'USD'.
*          /dmo/cl_flight_amdp=>convert_currency(
*            EXPORTING
*              iv_amount               = CONV #( <fs_target>-ProductPrice )
*              iv_currency_code_source = <fs_target>-PriceUnit
*              iv_currency_code_target = 'EUR'
*              iv_exchange_rate_date   = cl_abap_context_info=>get_system_date(  )
*            IMPORTING
*              ev_amount               = DATA(lv_amount)
*          ).
*        ENDIF.
      ENDLOOP.
      "Insertting values into unmanaged transactional buffer
      APPEND VALUE #(
      instance         = CORRESPONDING #( VALUE #( lwa_entities_cba-%target[ 1 ] ) )
      poorder          = lwa_entities_cba-PoOrder
      cid              = VALUE #( lwa_entities_cba-%target[ 1 ]-%cid )
      pid              = uuid_x16
      changed          = abap_true
      deleted          = abap_false
      ) TO lhc_helper=>root_child.

      APPEND VALUE #(
      %pid = uuid_x16
      %cid = VALUE #( lwa_entities_cba-%target[ 1 ]-%cid )
      %key = lwa_entities_cba-%key
      ) TO mapped-purchaseitem.


    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_PurchaseItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE PurchaseItem.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE PurchaseItem.

    METHODS read FOR READ
      IMPORTING keys FOR READ PurchaseItem RESULT result.

    METHODS rba_Poheader FOR READ
      IMPORTING keys_rba FOR READ PurchaseItem\_Poheader FULL result_requested RESULT result LINK association_links.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE PurchaseItem.

ENDCLASS.

CLASS lhc_PurchaseItem IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
    IF keys IS NOT INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD rba_Poheader.
    IF keys_rba IS NOT INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_PURCHASEHEADERTP_UM_R19 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

    METHODS adjust_numbers REDEFINITION.

  PRIVATE SECTION.
    DATA : lv_maxpo TYPE ebeln.

ENDCLASS.

CLASS lsc_ZI_PURCHASEHEADERTP_UM_R19 IMPLEMENTATION.

  METHOD finalize.

    LOOP AT lhc_helper=>root_buffer ASSIGNING FIELD-SYMBOL(<cid_del>).
      CLEAR <cid_del>-cid.
    ENDLOOP.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    IF lhc_helper=>gwa_transfer IS NOT INITIAL.
      DATA(lwa_poheader) = lhc_helper=>gwa_transfer[ 1 ].
      zcl_createpo=>create_po( gwa_poheader =  lwa_poheader ).
    ENDIF.
    IF lhc_helper=>gv_poorder IS NOT INITIAL.
      zcl_createpo=>delete_po( gv_poorder =  lhc_helper=>gv_poorder ).
    ENDIF.
    IF lhc_helper=>gwa_item IS NOT INITIAL.
      zcl_createpo=>create_po_items( gwa_items = lhc_helper=>gwa_item ).
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    CLEAR : lhc_helper=>root_buffer,
            lhc_helper=>gwa_item.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

  METHOD adjust_numbers.
    IF lhc_helper=>gwa_transfer IS NOT INITIAL.
      SELECT SINGLE MAX( PoOrder )
           FROM ZI_PurchaseHeaderTP_UM_R19
           INTO @lv_maxpo.
      IF lv_maxpo IS NOT INITIAL.
        lv_maxpo += 1.
        lv_maxpo = |{ lv_maxpo ALPHA = IN }|.
      ENDIF.

      MODIFY lhc_helper=>gwa_transfer FROM
              VALUE zpoheader_db_r19( po_order = lv_maxpo ) INDEX 1 TRANSPORTING po_order.

      APPEND VALUE #(
      %pid = VALUE #( lhc_helper=>root_buffer[ 1 ]-pid OPTIONAL )
      poorder = lv_maxpo
      %tmp-poorder = lv_maxpo
      ) TO mapped-purchaseheader.

    ELSEIF lhc_helper=>root_child IS NOT INITIAL.

      READ ENTITY IN LOCAL MODE ZI_PurchaseItemTP_UM_R19
      FIELDS ( PoOrder PoItem )
      WITH VALUE #( ( %key-poorder = lhc_helper=>root_child[ 1 ]-poorder ) )
      RESULT DATA(lt_items)
      FAILED DATA(lt_items_failed).

      DATA(lv_poorder) = lhc_helper=>root_child[ 1 ]-poorder.


*      READ ENTITIES OF ZI_PurchaseHeaderTP_UM_R19 IN LOCAL MODE
*      ENTITY PurchaseItem
*      FIELDS ( PoOrder PoItem )
*      WITH VALUE #( ( %key-PoOrder = lhc_helper=>root_child[ 1 ]-poorder ) )
*      RESULT DATA(lt_items)
*      FAILED DATA(lt_items_failed).

      DATA(lwa_child_inst) = VALUE #( lhc_helper=>root_child[ 1 ]-instance OPTIONAL ).

      SELECT SINGLE MAX( PoItem )
             FROM ZC_PurchaseItemTP_UM_R19
             WHERE PoOrder = @lv_poorder
             INTO @DATA(lv_inc).

      IF lv_inc IS NOT INITIAL.
        lv_inc += 10.
        lwa_child_inst-PoItem = lv_inc.
      ELSE.
        lv_inc = 10.
        lwa_child_inst-PoItem = lv_inc.
      ENDIF.

      lhc_helper=>gwa_item = CORRESPONDING #( lwa_child_inst MAPPING FROM ENTITY ).

      APPEND VALUE #(
            %pid = VALUE #( lhc_helper=>root_child[ 1 ]-pid OPTIONAL )
            poorder = lv_poorder
            poitem  = lv_inc
            %tmp-poorder = lv_poorder
            %tmp-poitem = lv_inc
            ) TO mapped-purchaseitem.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
