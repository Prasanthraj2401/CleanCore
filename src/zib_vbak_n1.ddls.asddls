@EndUserText.label: 'VBAK - Basic Interface View'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

define view entity ZIB_VBAK_N1
  as select from vbak
{
  @EndUserText.label: 'Sales Document'
  key vbeln as Vbeln,

  @EndUserText.label: 'Created On'
      erdat as Erdat,

  @EndUserText.label: 'Created By'
      ernam as Ernam,

  @EndUserText.label: 'Sales Document Category'
      vbtyp as Vbtyp,

  @EndUserText.label: 'Sales Organization'
      vkorg as Vkorg
}