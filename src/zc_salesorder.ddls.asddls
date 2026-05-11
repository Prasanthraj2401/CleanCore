@EndUserText.label: 'Sales Order Consumption View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZC_SalesOrder
  as projection on ZI_SalesOrder
{
  key Vbeln,
      Erdat,
      Ernam,
      Vbtyp,
      Vkorg
}