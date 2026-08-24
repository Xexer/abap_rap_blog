@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Participant Draft View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZBS_I_SinParticipantDraft
  as select from zbs_tst_sinpad
{
  key participantkey as ParticipantKey,
      participant    as Participant,
      navigationkey  as NavigationKey,
      userid         as UserID,
      draftentitycreationdatetime,
      draftentitylastchangedatetime,
      draftadministrativedatauuid,
      draftentityoperationcode,
      hasactiveentity,
      draftfieldchanges
}
where userid = $session.user
