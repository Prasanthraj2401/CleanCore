@EndUserText.label: 'EKKO - Basic Interface View'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AbapCatalog.sqlViewName: 'ZIBV_EKKO'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

define view entity ZIB_EKKO
  as select from ekko as Ekko
{
  @EndUserText.label: 'Purchase Order'
  key ebeln as Ebeln,

  @EndUserText.label: 'Company Code'
      bukrs as Bukrs,

  @EndUserText.label: 'Vendor'
      lifnr as Lifnr,

  @EndUserText.label: 'PO Date'
      bedat as Bedat
}