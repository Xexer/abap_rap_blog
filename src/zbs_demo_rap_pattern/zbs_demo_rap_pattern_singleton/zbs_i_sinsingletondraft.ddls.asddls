@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Singleton Draft'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZBS_I_SinSingletonDraft
  as select from zbs_tst_singled
{
  key navigationkey      as NavigationKey,
      userid             as UserID,
      username           as UserName,
      randomid           as RandomId,
      localcreatedby     as LocalCreatedBy,
      locallastchangedby as LocalLastChangedBy,
      locallastchangedat as LocalLastChangedAt,
      lastchangedat      as LastChangedAt,
      draftentitycreationdatetime,
      draftentitylastchangedatetime,
      draftadministrativedatauuid,
      draftentityoperationcode,
      hasactiveentity,
      draftfieldchanges
}
where
  userid = $session.user
