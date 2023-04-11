@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Po Item Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { title: {
    type: #STANDARD,    
    value: 'Material'     
}}
define view entity ZC_PurchaseItemDet_R19 as select from ZI_PurchaseItem_R19
association to parent ZC_PurchaseHeaderDet_R19 as _PoHeader on $projection.PoOrder = _PoHeader.PoOrder
{
    key PoOrder,
    @UI.lineItem: [{ position: 10, label: 'Item' }]
    key PoItem,   
    ShortText,
    @UI.lineItem: [{ position: 20, label: 'Material' }]
    Material,
     @UI.lineItem: [{ position: 30, label: 'Plant' }]
    Plant,
     @UI.lineItem: [{ position: 40, label: 'Material Group' }]
    MatGroup,
    @Semantics.quantity.unitOfMeasure: 'OrderUnit'
     @UI.lineItem: [{ position: 50, label: 'Order Qty' }]
    OrderQunt,     
    OrderUnit,
    @Semantics.amount.currencyCode: 'PriceUnit'
     @UI.lineItem: [{ position: 60, label: 'Prod Price' }]
    ProductPrice,    
    PriceUnit,
     @UI.lineItem: [{ position: 70, label: 'Item Price' }]
    ItemPrice,
    LocalLastChangedBy,
    LocalLastChangedAt,
    /* Associations */
    _Currency,
    _PoHeader
}
