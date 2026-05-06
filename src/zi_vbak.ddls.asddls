@EndUserText.label: 'ZD SD ALV'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZI_VBAK
  as select from ZIB_VBAK as Vbak
{
  key Vbak.Vbeln as Vbeln,
      @Semantics.systemDateTime.createdAt: true
      Vbak.Erdat as Erdat,
      @Semantics.user.createdBy: true
      Vbak.Ernam as Ernam,
      Vbak.Vbtyp as Vbtyp,
      Vbak.Vkorg as Vkorg
}
