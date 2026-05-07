@EndUserText.label: 'EKPO - Basic Interface View'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

define view entity ZIB_EKPO
  as select from ekpo
{
  key ebeln as Ebeln,
      ebelp as Ebelp,
      matnr as Matnr,
      menge as Menge,
      meins as Meins
}