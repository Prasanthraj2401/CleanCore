@EndUserText.label: 'ZAA BGJOB 01'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZI_AABGJOB01
  as select from ZIB_AABGJOB01 as Aabgjob01
{
  key Aabgjob01.Jobname as Jobname,
      Aabgjob01.Jobcount as Jobcount,
      @Semantics.systemDateTime.createdAt: true
      Aabgjob01.CreatedAt  as CreatedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      Aabgjob01.ChangedAt  as ChangedAt,
      @Semantics.user.createdBy: true
      Aabgjob01.CreatedBy  as CreatedBy,
      @Semantics.user.lastChangedBy: true
      Aabgjob01.ChangedBy  as ChangedBy
}
