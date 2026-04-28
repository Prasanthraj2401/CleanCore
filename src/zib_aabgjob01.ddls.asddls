@EndUserText.label: 'ZTB_AABGJOB01 - Basic Interface View'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

define view entity ZIB_AABGJOB01
  as select from ztb_aabgjob01
{
  key jobname as Jobname,
      jobcount as Jobcount,
      @Semantics.systemDateTime.createdAt: true
      created_at  as CreatedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at  as ChangedAt,
      @Semantics.user.createdBy: true
      created_by  as CreatedBy,
      @Semantics.user.lastChangedBy: true
      changed_by  as ChangedBy
}