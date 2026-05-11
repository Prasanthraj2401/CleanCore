@EndUserText.label: 'Purchase Order Interface View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZI_PurchaseOrder
  as select from ZIB_EKKO as Ekko

  association [0..*] to ZIB_EKPO AS Ekpo
    on $projection.Ebeln = Ekpo.Ebeln

{
  @EndUserText.label: 'Purchase Order'
  key Ekko.Ebeln   as Ebeln,

  @EndUserText.label: 'Company Code'
      Ekko.Bukrs   as Bukrs,

  @EndUserText.label: 'Vendor'
      Ekko.Lifnr   as Lifnr,

  @EndUserText.label: 'PO Date'
      Ekko.Bedat   as Bedat,

  /* Association */
  _Ekpo
}