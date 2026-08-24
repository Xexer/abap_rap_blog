@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Singleton Root Entity'
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'NavigationKey' ]
define root view entity ZBS_R_SinEntityTP
  as select from    I_Language
    left outer join zbs_tst_single as _Single on 0 = 0
  composition of exact one to many ZBS_I_SinParticipant as _Participant
{
  key 1                             as NavigationKey,
  key $session.user                 as UserID,
      _Single.name                  as UserName,
      _Single.random_number         as RandomId,
      _Single.local_created_by      as LocalCreatedBy,
      _Single.local_last_changed_by as LocalLastChangedBy,
      _Single.local_last_changed    as LocalLastChangedAt,
      _Single.last_changed          as LastChangedAt,
      _Participant
}
where
  I_Language.Language = $session.system_language
