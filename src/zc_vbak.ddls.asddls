@EndUserText.label: 'ZD SD ALV - Consumption View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_VBAK
  as projection on root ZI_VBAK
{
  key Vbeln,
      Erdat,
      Ernam,
      Vbtyp,
      Vkorg
}
