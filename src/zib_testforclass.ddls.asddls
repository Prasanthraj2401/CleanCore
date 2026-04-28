@EndUserText.label: 'ZTB_TESTFORCLASS - Basic Interface View'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

define view entity ZIB_TESTFORCLASS
  as select from ztb_testforclass
{
  key business_key as BusinessKey,
      description as Description,
      @Semantics.systemDateTime.createdAt: true
      created_at  as CreatedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at  as ChangedAt,
      @Semantics.user.createdBy: true
      created_by  as CreatedBy,
      @Semantics.user.lastChangedBy: true
      changed_by  as ChangedBy
}