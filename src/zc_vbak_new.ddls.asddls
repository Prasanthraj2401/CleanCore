@EndUserText.label: 'Sales Order Consumption View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZC_VBAK_NEW
  as projection on ZI_VBAK_NEW
{
  key Vbeln,
      Erdat,
      Ernam,
      Vbtyp,
      Vkorg
}