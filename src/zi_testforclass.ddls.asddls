@EndUserText.label: 'ZTEST FOR CLASS'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZI_TESTFORCLASS
  as select from ZIB_TESTFORCLASS as Testforclass
{
  key Testforclass.BusinessKey as BusinessKey,
      @Semantics.systemDateTime.createdAt: true
      Testforclass.CreatedAt  as CreatedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      Testforclass.ChangedAt  as ChangedAt,
      @Semantics.user.createdBy: true
      Testforclass.CreatedBy  as CreatedBy,
      @Semantics.user.lastChangedBy: true
      Testforclass.ChangedBy  as ChangedBy
}
