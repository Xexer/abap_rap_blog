@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Additional Informations'
define view entity ZBS_B_DRPAdditionalCurrency
  as select from zbs_drp_addcurr
{
  key currency           as Currency,
      ccomment           as CurrencyComment,
      documentation      as Documentation,
      picture_url        as PictureURL,
      last_editor        as LastEditor,
      last_changed       as LastChanged,
      local_last_changed as LocalLastChanged
}
