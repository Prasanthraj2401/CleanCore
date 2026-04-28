@EndUserText.label: 'ZTEST FOR CLASS - Consumption View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_TESTFORCLASS
  as projection on root ZI_TESTFORCLASS
{
  key BusinessKey,
      Description,
      CreatedAt,
      ChangedAt,
      CreatedBy,
      ChangedBy
}
