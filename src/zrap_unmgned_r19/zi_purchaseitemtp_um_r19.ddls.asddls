@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Purchase Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #S,
    dataClass: #TRANSACTIONAL
}
define view entity ZI_PurchaseItemTP_UM_R19
as select from ZI_PurchaseItem_R19
association to parent ZI_PurchaseHeaderTP_UM_R19 as _PoHeader on $projection.PoOrder = _PoHeader.PoOrder
{
  key PoOrder,
  key PoItem,
  ShortText,
  Material,
  Plant,
  MatGroup,
  @Semantics.quantity.unitOfMeasure: 'OrderUnit'
  OrderQunt,
  OrderUnit,
  @Semantics.amount.currencyCode: 'PriceUnit'
  ProductPrice,
  PriceUnit,
  ItemPrice,
  LocalLastChangedBy,
  LocalLastChangedAt,
  /* Associations */
  _Currency,
  _PoHeader  
}
