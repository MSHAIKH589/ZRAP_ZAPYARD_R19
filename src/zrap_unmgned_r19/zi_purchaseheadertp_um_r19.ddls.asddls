@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unmanaged PO Header view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #S,
    dataClass: #TRANSACTIONAL
}
define root view entity ZI_PurchaseHeaderTP_UM_R19
  as select from ZI_OverAllPrice_R19
  composition [*] of ZI_PurchaseItemTP_UM_R19 as _PoItems
  association [1] to ZC_ORDERTYPE_R19         as _OrderType on $projection.PoType = _OrderType.PoType
  association [1] to ZC_SUPPLIER_R19          as _Supplier  on $projection.Supplier = _Supplier.Supplierid
  association [1] to ZC_PURCHASESTATUS_R19    as _PoStatus  on $projection.PurchaseStatus = _PoStatus.Postatus
{
  key PoOrder,
      PoDesc,
      PurchaseTotalPrice,
      PriceUnit,
      PoType,
      CompCode,
      PoOrg,
      PurchaseStatus,
      case
         when PurchaseStatus = '01' then 2
         when PurchaseStatus = '02' then 3
         when PurchaseStatus = '03' then 1
         else 0
         end as CriticalityValue,
      Supplier,
      Imageurl,
      CreateBy,
      CreatedDateTime,
      ChangedDateTime,
      LocalLastChangedBy,
      local_last_changed_at,
      local_last_changed_at1,
      /* Associations */
      _OrderType,
      _PoItems,
      _Supplier,
      _PoStatus
}
