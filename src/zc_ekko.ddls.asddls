@EndUserText.label: 'ZSIRA ABAP REPORT - Consumption View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_EKKO
  as projection on ZI_EKKO
{
  key Ebeln,
      Bukrs,
      Lifnr,
      Bedat,
      _Ekpo
}
