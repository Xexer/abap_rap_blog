@ClientHandling.type: #CLIENT_DEPENDENT
@AbapCatalog.deliveryClass: #APPLICATION_DATA
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Draft for Invoice'
define table entity ZBS_T_CDSPatternInvDraft
{
  key DocumentNumber : abap.char(8);
  key DraftUUID      : sdraft_uuid;
      DocumentDate   : abap.datn;
      DocumentTime   : abap.timn;
      PartnerNumber  : abap.char(10);
      @Semantics.user.createdBy: true
      LocalCreatedBy     : abp_creation_user;
      @Semantics.systemDateTime.createdAt: true
      LocalCreatedAt     : abp_creation_tstmpl;
      @Semantics.user.localInstanceLastChangedBy: true
      LocalLastChangedBy : abp_locinst_lastchange_user;
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt : abp_locinst_lastchange_tstmpl;
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt      : abp_lastchange_tstmpl;
      include SYCH_BDL_DRAFT_ADMIN_INC.* signature only;
}
