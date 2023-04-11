@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Po Header Agg View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_OverAllPrice_R19 as select from ZI_PuchaseOrderHeader_R19 {
    key PoOrder,
    PoDesc,
    @Semantics.amount.currencyCode: 'PriceUnit'
    sum( _PoItems.ItemPrice ) as PurchaseTotalPrice,
    _PoItems.PriceUnit,    
    PoType,
    CompCode,
    PoOrg,
    PurchaseStatus,
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
    _Supplier
}
group by
    PoOrder,
    PoDesc,
    PoType,
    CompCode,
    PoOrg,
    PurchaseStatus,
    Supplier,
    Imageurl,
    CreateBy,
    CreatedDateTime,
    ChangedDateTime,
    LocalLastChangedBy,
    _PoItems.PriceUnit,
    local_last_changed_at,
    local_last_changed_at1
    
