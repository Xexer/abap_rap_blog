@EndUserText.label: 'RAP consumption for partner'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZBS_C_RAPPartner
  provider contract transactional_query
  as projection on ZBS_I_RAPPartner
{
  key PartnerNumber,
      PartnerName,
      Street,
      City,
      Country,
      PaymentCurrency
}
