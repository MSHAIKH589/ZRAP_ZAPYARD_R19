@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZC_SUPPLIER_R19
  as select from ZI_Supplier_R19
{

      @ObjectModel.text.element: ['SupplierName']
  key Supplierid,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Search.ranking: #HIGH
      @EndUserText.label: 'Supplier Name'
      @Semantics.text: true
      @Semantics.name.fullName: true
      @UI.identification: [{ position: 10, label: 'Supplier Name' }]
      SupplierName,
      @EndUserText.label: 'Email'
      @Semantics.eMail.type: [  #WORK ]
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @UI.identification: [{ position: 20, label: 'Email address' }] 
     EmailAddress,
      @EndUserText.label: 'Phone Number'
      @Semantics.telephone.type: [ #WORK ]
      @UI.identification: [{ position: 30, label: 'Phone Number' }]
      PhoneNumber,
      @EndUserText.label: 'Fax Number'
      @Semantics.telephone.type: [ #FAX ]
      @UI.identification: [{ position: 40, label: 'Fax Number' }] 
      FaxNumber,
      '1000' as CompanyCodeSupplier,
      WebAddress
}
