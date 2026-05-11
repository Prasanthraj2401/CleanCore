@EndUserText.label: 'EKPO - Basic Interface View'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AbapCatalog.sqlViewName: 'ZIBV_EKPO'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

define view entity ZIB_EKPO
  as select from ekpo as Ekpo
{
  @EndUserText.label: 'Purchase Order'
  key ebeln as Ebeln,

  @EndUserText.label: 'PO Item'
  key ebelp as Ebelp,

  @EndUserText.label: 'Material'
      matnr as Matnr,

  @EndUserText.label: 'Quantity'
  @Semantics.quantity.unitOfMeasure: 'Meins'
      menge as Menge,

  @EndUserText.label: 'Unit of Measure'
      meins as Meins,

  @EndUserText.label: 'Effective Value'
  @Semantics.amount.currencyCode: 'Waers'
      effwr as Effwr,

  @EndUserText.label: 'Goods Receipt Indicator'
      xoblr as Xoblr,

  @EndUserText.label: 'Customer'
      kunnr as Kunnr,

  @EndUserText.label: 'Address'
      adrnr as Adrnr,

  @EndUserText.label: 'PO Collective Number'
      ekkol as Ekkol,

  @EndUserText.label: 'Cash Discount'
      sktof as Sktof,

  @EndUserText.label: 'Currency'
      waers as Waers
}