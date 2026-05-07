@EndUserText.label: 'VBAK - Basic Interface View'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

define view entity ZIB_VBAK
  as select from vbak
{
  key vbeln as Vbeln,
      @Semantics.systemDateTime.createdAt: true
      erdat as Erdat,
      @Semantics.user.createdBy: true
      ernam as Ernam,
      vbtyp as Vbtyp,
      vkorg as Vkorg
}