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
      excel_attachment   as ExcelAttachement,
      excel_mimetype     as ExcelMimetype,
      excel_filename     as ExcelFilename,
      picture_attachment as PictureAttachement,
      picture_mimetype   as PictureMimetype,
      picture_filename   as PictureFilename,
      last_changed       as LastChanged,
      local_last_changed as LocalLastChanged
}
