@EndUserText.label: 'Projection Itm View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_PRJ_PURCHASEITEMDET_R19 as projection on ZC_PurchaseItemDet_R19 {
    key PoOrder,
    key PoItem,
    ShortText,
    Material,
    Plant,
    MatGroup,
    OrderQunt,
    OrderUnit,
    ProductPrice,
    PriceUnit,
    ItemPrice,
    LocalLastChangedBy,
    /* Associations */
    _Currency,
    _PoHeader : redirected to parent ZC_PRJ_PURCHASEHEADERDET_R19
}
