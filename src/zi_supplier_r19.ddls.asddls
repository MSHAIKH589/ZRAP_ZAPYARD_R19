@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Po Supplier View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_Supplier_R19 as select from zsupplier_db_r19 {
    key supplierid as Supplierid,
    supplier_name as SupplierName,
    email_address as EmailAddress,
    phone_number as PhoneNumber,
    fax_number as FaxNumber,
    web_address as WebAddress
}
