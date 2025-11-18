@EndUserText.label: 'Custom Tile'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_BS_DEMO_TILE_QUERY'
define custom entity ZBS_I_DMOCustomTile
{
  key key_field    : abap.char(20);
      title        : abap.string;
      subtitle     : abap.string;
      icon         : abap.string;
      @OData.property.name: 'number'
      numberOutput : abap.dec( 15, 4 );
      numberDigits : abap.int2;
      numberFactor : abap.string;
      numberState  : abap.string;
      numberUnit   : abap.string;
      stateArrow   : abap.string;
      info         : abap.string;
      infoState    : abap.string;
}
