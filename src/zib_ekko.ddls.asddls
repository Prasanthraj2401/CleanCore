@EndUserText.label: 'EKKO - Basic Interface View'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

define view entity ZIB_EKKO
  as select from ekko
{
  key ebeln as Ebeln,
      bukrs as Bukrs,
      lifnr as Lifnr,
      bedat as Bedat
}