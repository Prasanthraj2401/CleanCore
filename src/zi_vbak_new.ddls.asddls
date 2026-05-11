@EndUserText.label: 'Sales Order Interface View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZI_VBAK_NEW
  as select from ZIB_VBAK_NEW as Vbak
{
  key Vbak.Vbeln  as Vbeln,
      Vbak.Erdat  as Erdat,
      Vbak.Ernam  as Ernam,
      Vbak.Vbtyp  as Vbtyp,
      Vbak.Vkorg  as Vkorg
}