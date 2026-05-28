@AccessControl.authorizationCheck: #NOT_REQUIRED
define external entity ZBS_X_DemoSQLPerformance external name "PERFORMANCE"
{
      @EndUserText.label: 'UUID'
      @EndUserText.quickInfo: '16 Byte UUID in 16 Bytes (Raw Format)'
  key Identifier        : abap.raw( 16 )    external name "Identifier";
      ItemDescription   : abap.char( 40 )   external name "ItemDescription";
      RandomDescription : abap.char( 150 )  external name "RandomDescription";
      @Semantics.amount.currencyCode: 'Currency'
      Amount            : abap.dec( 15, 2 ) external name "Amount";
      Currency          : abap.cuky         external name "Currency";
      BlobObject        : abap.string( 0 )  external name "BlobObject";
      NewDate           : abap.char( 8 )    external name "NewDate";
      NewTime           : abap.char( 6 )    external name "NewTime";
      UTCTimestamp      : abap.utclong      external name "UTCTimestamp";
}
with federated data provided by ZBS_DEMO_PERF_EXT_SCHEMA
