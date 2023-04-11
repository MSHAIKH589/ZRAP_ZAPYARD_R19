@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Po Header Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['PoOrder']
@Search.searchable: true
define root view entity ZC_PurchaseHeaderDet_R19  as select from ZI_OverAllPrice_R19
  composition[*] of ZC_PurchaseItemDet_R19 as _PoItems
//  composition[*] of ZC_Attachment_R19 as _Attachment
//  association [*] to ZC_PurchaseItemDet_R19  as _PoItems on $projection.PoOrder = _PoItems.PoOrder
  association [1] to ZC_SUPPLIER_R19         as _Supplier  on $projection.Supplier = _Supplier.Supplierid
  association [1] to ZC_ORDERTYPE_R19        as _OrderType on $projection.PoType = _OrderType.PoType
  association [1] to ZC_PURCHASESTATUS_R19   as _Status    on $projection.PurchaseStatus = _Status.Postatus
//  association [*] to ZC_Attachment_R19       as _Attachment on $projection.PoOrder = _Attachment.PoOrder
{
    @ObjectModel.text.element: ['PoDesc']
    key PoOrder,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    @Search.ranking: #HIGH
    PoDesc,    
    @Semantics.amount.currencyCode: 'PriceUnit'
    PurchaseTotalPrice,
    PriceUnit,
    @Consumption.valueHelpDefinition: [{ entity: {
        name: 'ZC_ORDERTYPE_R19',
        element: 'PoType'
    } }]
    PoType,
    CompCode,
    PoOrg,
    @ObjectModel.text.element: ['Statusdesc']
    PurchaseStatus,
    _Status.Statusdesc,  
    @Consumption.valueHelpDefinition: [{ entity: {
        name: 'ZC_SUPPLIER_R19',
        element: 'Supplierid'
    } , additionalBinding: [{ element: 'CompanyCodeSupplier' ,localElement: 'CompCode' }]}]   
    @ObjectModel.text.element: ['SupplierName']
    @Consumption.filter:{multipleSelections: false }   
    Supplier, 
     _Supplier.SupplierName as SupplierName,
    @Semantics.imageUrl: true   
    Imageurl,
    case
      when PurchaseStatus = '01' then 2
      when PurchaseStatus = '02' then 3
      when PurchaseStatus = '03' then 1
      else 0
      end                    as CriticalityValue,
    @Semantics.user.createdBy: true  
    CreateBy,
    @Semantics.systemDateTime.createdAt: true   
    CreatedDateTime,
    @Semantics.systemDateTime.lastChangedAt: true
    ChangedDateTime,
    @Semantics.user.lastChangedBy: true
    LocalLastChangedBy,    
    local_last_changed_at,
    @Semantics.systemDateTime.lastChangedAt: true
    local_last_changed_at1,
    /* Associations */
    _OrderType,
    @Search.defaultSearchElement: true
    _PoItems,
    _Supplier,
    _Status
//    _Attachment
}
