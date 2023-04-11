@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Po Header View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PuchaseOrderHeader_R19
  as select from zpoheader_db_r19
  association [0..*] to ZI_PurchaseItem_R19   as _PoItems   on $projection.PoOrder = _PoItems.PoOrder
  association [1]    to ZI_Supplier_R19       as _Supplier  on $projection.Supplier = _Supplier.Supplierid
  association [1]    to ZI_OrderType_R19      as _OrderType on $projection.PoType = _OrderType.PoType
  association [1]    to ZI_PURCHASESTATUS_R19 as _PoStatus  on $projection.PurchaseStatus = _PoStatus.Postatus
  association[0..*]  to ZI_ATTACHMENT_R19     as _Attachment on $projection.PoOrder = _Attachment.PoOrder
{
  key po_order              as PoOrder,
      po_desc               as PoDesc,
      po_type               as PoType,
      comp_code             as CompCode,
      po_org                as PoOrg,
      po_status             as PurchaseStatus,
      supplier              as Supplier,
      imageurl              as Imageurl,
      create_by             as CreateBy,
      created_date_time     as CreatedDateTime,
      changed_date_time     as ChangedDateTime,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at,
      local_last_changed_at1,
      _PoItems,
      _Supplier,
      _OrderType,
      _PoStatus,
      _Attachment
}
