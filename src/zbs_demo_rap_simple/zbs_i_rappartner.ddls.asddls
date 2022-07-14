@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP interface for Partner'
define root view entity ZBS_I_RAPPartner
  as select from zbs_dmo_partner
{
  key partner          as PartnerNumber,
      name             as PartnerName,
      street           as Street,
      city             as City,
      country          as Country,
      payment_currency as PaymentCurrency
}
