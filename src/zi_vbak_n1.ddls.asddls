@EndUserText.label: 'VBAK Interface View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZI_VBAK_N1
  as select from ZIB_VBAK_N1 as Vbak
{
  key Vbak.Vbeln  as Vbeln,
      Vbak.Erdat  as Erdat,
      Vbak.Ernam  as Ernam,
      Vbak.Vbtyp  as Vbtyp,
      Vbak.Vkorg  as Vkorg
}