@EndUserText.label: 'Purchase Order Consumption View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZC_PurchaseOrder
  as projection on ZI_PurchaseOrder
{
  key Ebeln,
      Bukrs,
      Lifnr,
      Bedat,

      /* Association */
      _Ekpo
}