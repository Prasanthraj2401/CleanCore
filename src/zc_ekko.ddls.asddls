@EndUserText.label: 'ZSIRA PO DISP - Consumption View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_EKKO
  as projection on root ZI_EKKO
{
  key Ebeln,
      Bukrs,
      Lifnr,
      Bedat
}
