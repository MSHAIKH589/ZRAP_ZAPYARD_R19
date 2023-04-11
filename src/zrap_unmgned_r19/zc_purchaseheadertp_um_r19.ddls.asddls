@EndUserText.label: 'Unmanaged PO Header view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_PurchaseHeaderTP_UM_R19
  provider contract transactional_query
  as projection on ZI_PurchaseHeaderTP_UM_R19
{
  key PoOrder,
      PoDesc,
      PurchaseTotalPrice,
      PriceUnit,
      @Consumption.valueHelpDefinition: [{ entity: {
        name: 'ZC_ORDERTYPE_R19',
        element: 'PoType'
      } }]
      PoType,
      CompCode,
      PoOrg,
      PurchaseStatus,
      CriticalityValue,
      @Consumption.valueHelpDefinition: [{          
          entity: {
              name: 'ZC_SUPPLIER_R19',
              element: 'Supplierid'
          } }]  
      Supplier,
      Imageurl,
      @Semantics.user.createdBy: true
      CreateBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedDateTime,
      @Semantics.systemDateTime.lastChangedAt: true
      ChangedDateTime,
      @Semantics.user.localInstanceLastChangedBy: true
      LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at1,
      /* Associations */
      _OrderType,
      _PoItems : redirected to composition child ZC_PurchaseItemTP_UM_R19,
      _PoStatus,
      _Supplier
}
