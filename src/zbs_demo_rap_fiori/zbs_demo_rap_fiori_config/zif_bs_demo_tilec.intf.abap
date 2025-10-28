INTERFACE zif_bs_demo_tilec
  PUBLIC.

  TYPES:
    BEGIN OF configuration,
      title         TYPE string,
      subtitle      TYPE string,
      icon          TYPE string,
      info          TYPE string,
      info_state    TYPE string,
      number        TYPE p LENGTH 15 DECIMALS 4,
      number_digits TYPE i,
      number_factor TYPE string,
      number_state  TYPE string,
      number_unit   TYPE string,
      state_arrow   TYPE string,
    END OF configuration.

  CONSTANTS:
    BEGIN OF info_state,
      negative TYPE string VALUE `Negative`,
      neutral  TYPE string VALUE `Neutral`,
      positive TYPE string VALUE `Positive`,
      critical TYPE string VALUE `Critical`,
    END OF info_state.

  CONSTANTS:
    BEGIN OF number_state,
      none     TYPE string VALUE `None`,
      error    TYPE string VALUE `Error`,
      neutral  TYPE string VALUE `Neutral`,
      good     TYPE string VALUE `Good`,
      critical TYPE string VALUE `Critical`,
    END OF number_state.

  CONSTANTS:
    BEGIN OF arrow_state,
      none TYPE string VALUE `None`,
      up   TYPE string VALUE `Up`,
      down TYPE string VALUE `Down`,
    END OF arrow_state.

  METHODS get_configuration
    RETURNING VALUE(result) TYPE configuration.
ENDINTERFACE.
