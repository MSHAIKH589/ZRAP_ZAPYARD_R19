@EndUserText.label: 'Purchase Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo:{
typeName: 'PurchaseItem',
typeNamePlural: 'Purchase Items',

title:{ value: 'ShortText' },
description:{

label: 'Manage Purchase Orders',
type: #STANDARD,
value: 'PoItem'
}
}
define view entity ZC_PurchaseItemTP_UM_R19
  as projection on ZI_PurchaseItemTP_UM_R19
{
      @UI.facet: [{
          id: 'BasDat',
          purpose: #STANDARD,
          position: 10,
          label: 'Item Detail',
          type:#IDENTIFICATION_REFERENCE
      }]
      @UI.identification: [{ position: 10, label: 'Purchase Order' }]
  key PoOrder,
      @ObjectModel.text.element: ['ShortText']
      @UI.lineItem: [{ position: 10, label: 'Item No' }]
      @UI.identification: [{ position: 20, label: 'Item No' }]
  key PoItem,
      @UI.identification: [{ position: 80, label: 'Short Text' }]
      ShortText,
      @UI.lineItem: [{ position: 20, label: 'Material' }]
      @UI.identification: [{ position: 30, label: 'Material' }]
      Material,
      @UI.lineItem: [{ position: 30, label: 'Plant' }]
      @UI.identification: [{ position: 40, label: 'Plant' }]
      Plant,
      @UI.lineItem: [{ position: 40, label: 'Material Group' }]
      @UI.identification: [{ position: 50, label: 'Material Group' }]
      MatGroup,
      @UI.lineItem: [{ position: 50, label: 'Quantity' }]
      @UI.identification: [{ position: 60, label: 'Quantity' }]         
      OrderQunt,
      @UI.identification: [{ position: 90, label: 'Unit' }]       
      OrderUnit,
      @UI.lineItem: [{ position: 60, label: 'Price' }]
      @UI.identification: [{ position: 70, label: 'Product Price' }]
      ProductPrice,
      @UI.identification: [{ position: 90, label: 'PriceUnit' }]
      PriceUnit,
      @UI.lineItem: [{ position: 70, label: 'Item Price' }]
      ItemPrice,
      LocalLastChangedBy,
      LocalLastChangedAt,
      /* Associations */
      _Currency,
      _PoHeader : redirected to parent ZC_PurchaseHeaderTP_UM_R19
}
