@EndUserText.label: 'ZD SD ALV - Consumption View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_VBAK
  as projection on ZI_VBAK
{
  key Vbeln,
      Erdat,
      Ernam,
      Vbtyp,
      Vkorg
}
