@EndUserText.label: 'ZAA BGJOB 01 - Consumption View'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_AABGJOB01
  as projection on root ZI_AABGJOB01
{
  key Jobname,
      Jobcount,
      CreatedAt,
      ChangedAt,
      CreatedBy,
      ChangedBy
}
