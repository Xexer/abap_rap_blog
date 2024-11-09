@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Currency Overview'
define root view entity ZBS_R_DRPCurrency
  as select from I_Currency
  composition of many ZBS_I_DRPCurrencyCountry          as _Country
  association of one to one ZBS_B_DRPAdditionalCurrency as _Data on _Data.Currency = $projection.Currency
  association of one to one I_BusinessUserVH            as _User on _User.UserID = $projection.lasteditor
{
  key Currency,
      Decimals,
      CurrencyISOCode,
      AlternativeCurrencyKey,
      _Text[ Language = $session.system_language ].CurrencyName,
      _Text[ Language = $session.system_language ].CurrencyShortName,
      _Data.CurrencyComment,
      _Data.Documentation,
      _Data.PictureURL,
      _Data.LastEditor,
      _Data.ExcelAttachement,
      _Data.ExcelMimetype,
      _Data.ExcelFilename,
      _Data.PictureAttachement,
      _Data.PictureMimetype,
      _Data.PictureFilename,
      _Data.LastChanged,
      _Data.LocalLastChanged,
      _Country,
      _User
}
