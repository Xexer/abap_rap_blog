@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Participants'
@Metadata.allowExtensions: true
define view entity ZBS_I_SinParticipant
  as select from zbs_tst_sinpa
  association to parent ZBS_R_SinEntityTP as _MainForm on  $projection.NavigationKey = _MainForm.NavigationKey
                                                       and $projection.UserID        = _MainForm.UserID
{
  key uuid          as ParticipantKey,
      participant   as Participant,
      @Consumption.hidden: true
      1             as NavigationKey,
      @Consumption.hidden: true
      $session.user as UserID,
      _MainForm
}
