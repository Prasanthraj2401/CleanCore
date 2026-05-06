@EndUserText.label: 'EKKO - Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@UI.headerInfo: {
  typeName: 'Ekko',
  typeNamePlural: 'Ekkos',
  title: { type: #STANDARD, value: 'Ebeln' }
}

define root view entity ZC_EKKO
  as projection on ZI_EKKO
{
  @UI.lineItem: [{ position: 10, importance: #HIGH }]
  @UI.selectionField: [{ position: 10 }]
  Ebeln,
  @UI.lineItem: [{ position: 20, importance: #HIGH }]
  @UI.selectionField: [{ position: 20 }]
  Bukrs,
  @UI.lineItem: [{ position: 30, importance: #HIGH }]
  @UI.selectionField: [{ position: 30 }]
  Lifnr,
  @UI.lineItem: [{ position: 40, importance: #HIGH }]
  Bedat,
  _Ekpo
}