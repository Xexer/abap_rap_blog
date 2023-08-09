@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unmanaged Root'
define root view entity ZBS_R_DMOUnmanaged
  as select from zbs_dmo_unmgnd
{
  key gen_key as TableKey,
      text    as Description,
      cdate   as CreationDate
}
