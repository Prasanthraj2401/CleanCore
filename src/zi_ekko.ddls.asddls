@EndUserText.label: 'ZSIRA PO REPORT'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZI_EKKO
  as select from ZIB_EKKO as Ekko
  association [0..*] to ZIB_EKPO AS Ekpo
    on a.Ebeln = b.Ebeln
{
  key Ekko.Ebeln as Ebeln,
      Ekko.Bukrs as Bukrs,
      Ekko.Lifnr as Lifnr,
      Ekko.Bedat as Bedat,
      _Ekpo
}
