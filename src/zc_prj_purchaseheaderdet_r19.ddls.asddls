@EndUserText.label: 'Projection Hdr View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_PRJ_PURCHASEHEADERDET_R19 
provider contract transactional_query
as projection on ZC_PurchaseHeaderDet_R19 {
    key PoOrder,
    PoDesc,
    PurchaseTotalPrice,
    PriceUnit,
    PoType,
    CompCode,
    PoOrg,
    PurchaseStatus,
    Statusdesc,
    Supplier,
    SupplierName,
    Imageurl,
    CriticalityValue,
    CreateBy,
    CreatedDateTime,
    ChangedDateTime,
    LocalLastChangedBy,
    /* Associations */
    _OrderType,
    _PoItems : redirected to composition child ZC_PRJ_PURCHASEITEMDET_R19,
    _Status,
    _Supplier
}
