CLASS zcl_createpo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS : create_po IMPORTING gwa_poheader TYPE zpoheader_db_r19,
      delete_po IMPORTING gv_poorder TYPE ebeln,
      create_po_items IMPORTING gwa_items TYPE zpoitems_db_r19.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_createpo IMPLEMENTATION.


  METHOD create_po.
    DATA lwa_poheader TYPE zpoheader_db_r19.
    lwa_poheader = gwa_poheader.
    IF lwa_poheader IS NOT INITIAL.
      IF lwa_poheader-supplier IS NOT INITIAL.
        DATA(lv_supplier) = lwa_poheader-supplier.
        SHIFT lv_supplier BY 5 PLACES.
        lwa_poheader-supplier = lv_supplier.
      ENDIF.
      MODIFY zpoheader_db_r19 FROM @lwa_poheader.
    ENDIF.
  ENDMETHOD.
  METHOD delete_po.
    IF gv_poorder IS NOT INITIAL.
*      DELETE FROM zpoheader_db_r19 WHERE po_order = @gv_poorder.
      DATA(lv_poorder) = |{ gv_poorder ALPHA = IN }|.
      SELECT SINGLE * FROM
        zpoheader_db_r19
        WHERE po_order = @lv_poorder
        INTO @DATA(lwa_poheader).
      IF sy-subrc IS INITIAL.
        DELETE zpoheader_db_r19 FROM @lwa_poheader.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD create_po_items.
    IF gwa_items IS NOT INITIAL.
      MODIFY zpoitems_db_r19 FROM @gwa_items.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
