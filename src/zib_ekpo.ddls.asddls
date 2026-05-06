@EndUserText.label: 'EKPO - Basic Interface View'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

define view entity ZIB_EKPO
  as select from ekpo
{
  key ebeln as Ebeln,
  key ebelp as Ebelp,
      matnr as Matnr,
  @Semantics.quantity.unitOfMeasure: 'Meins'
      menge as Menge,
      meins as Meins,
      effwr as Effwr,
      xoblr as Xoblr,
      kunnr as Kunnr,
      adrnr as Adrnr,
      ekkol as Ekkol,
      sktof as Sktof
}