@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption Attachment'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_Attachment_R19 as select from ZI_ATTACHMENT_R19
//    association to parent ZC_PurchaseHeaderDet_R19 as _PoHeader on $projection.PoOrder = _PoHeader.PoOrder
 {
    @UI.lineItem: [{ position: 10, label: 'Po Order' }]
    key PoOrder,   
    key AttahId,
    Attachment,
    Mimetype,
    Filename,
    LastChangedAt
//    _PoHeader
}
