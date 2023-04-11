CLASS zcl_data_uploader DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DATA_UPLOADER IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT * FROM zpoheader_db_r19
    INTO TABLE @DATA(lt_po).

    LOOP AT lt_po ASSIGNING FIELD-SYMBOL(<fs_po>).
      DATA(lv_tabix) = abs( 3 - sy-tabix ).
      CASE lv_tabix.
        WHEN 1.
          <fs_po>-po_status = '01'.
        WHEN 2.
          <fs_po>-po_status = '02'.
        WHEN 3.
          <fs_po>-po_status = '03'.
        WHEN OTHERS.
          <fs_po>-po_status = '03'.
      ENDCASE.
    ENDLOOP.

    UPDATE zpoheader_db_r19 FROM TABLE @lt_po.
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.
*    DELETE FROM zpoitems_db_r19.
*
*    INSERT zpoitems_db_r19 FROM ( SELECT * FROM zpoitems_db ).
*    IF sy-subrc = 0.
*      COMMIT WORK.
*      out->write( data = |'Data Uploaded'| ).
*    ENDIF.

*    DELETE FROM zsupplier_db_r19.
*
*    INSERT zsupplier_db_r19 FROM ( SELECT * FROM zsupplier_db ).
*    IF sy-subrc = 0.
*      COMMIT WORK.
*      out->write( data = |'Data Uploaded'| ).
*    ENDIF.
*    DELETE FROM zpo_odr_type_r19.
*
*    INSERT zpo_odr_type_r19 FROM ( SELECT * FROM zpo_order_type ).
*    IF sy-subrc = 0.
*      COMMIT WORK.
*      out->write( data = |'Data Uploaded'| ).
*    ENDIF.

*    INSERT zPOSTATUS_DB_R19 FROM ( SELECT * FROM zpoSTATUS ).
*    IF sy-subrc = 0.
*      COMMIT WORK.
*      out->write( data = |'Data Uploaded'| ).
*    ENDIF.

*    UPDATE zpoheader_db_r19 SET supplier = '00800'
*        WHERE po_order = '0000001007'.
*    IF sy-subrc = 0.
*      COMMIT WORK.
*    ENDIF.

  ENDMETHOD.
ENDCLASS.
