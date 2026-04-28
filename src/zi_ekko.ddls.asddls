@EndUserText.label: 'ZSIRA PO DISP'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZI_EKKO
  as select from ZIB_EKKO as Ekko
{
  key Ekko.Ebeln as Ebeln,
      Ekko.Bukrs as Bukrs,
      Ekko.Lifnr as Lifnr,
      Ekko.Bedat as Bedat
}
