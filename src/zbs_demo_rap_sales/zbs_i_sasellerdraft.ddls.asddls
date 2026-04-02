@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Draft for Seller'
define view entity ZBS_I_SASellerDraft
  as select from zbs_saseller_d
{
  key uuid                          as UUID,
      parentuuid                    as ParentUUID,
      sellerid                      as SellerId,
      quota                         as Quota,
      confirmed                     as Confirmed,
      draftentitycreationdatetime   as Draftentitycreationdatetime,
      draftentitylastchangedatetime as Draftentitylastchangedatetime,
      draftadministrativedatauuid   as Draftadministrativedatauuid,
      draftentityoperationcode      as Draftentityoperationcode,
      hasactiveentity               as Hasactiveentity,
      draftfieldchanges             as Draftfieldchanges
}
