@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attachment view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ATTACHMENT_R19 as select from zrap_attachement {
    key po_order as PoOrder,
    key attah_id as AttahId,
    attachment as Attachment,
    mimetype as Mimetype,
    filename as Filename,
    last_changed_at as LastChangedAt
}
