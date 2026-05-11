@EndUserText.label: 'Sales Order Interface View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZI_SalesOrder
  as select from ZIB_VBAK_N as Vbak
{
  @EndUserText.label: 'Sales Document'
  key Vbak.Vbeln   as Vbeln,

  @EndUserText.label: 'Creation Date'
      Vbak.Erdat   as Erdat,

  @EndUserText.label: 'Created By'
      Vbak.Ernam   as Ernam,

  @EndUserText.label: 'SD Document Category'
      Vbak.Vbtyp   as Vbtyp,

  @EndUserText.label: 'Sales Organization'
      Vbak.Vkorg   as Vkorg
}