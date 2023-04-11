@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
//Enable text search and also make it Valuhelp
define view entity ZC_ORDERTYPE_R19
  as select from ZI_OrderType_R19
{
      @Search.defaultSearchElement: true

  key PoType,
      IsActive
}
