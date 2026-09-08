class ZCL_EUI_ALV definition
  public
  inheriting from ZCL_EUI_MSG_MANAGER
  final
  create public .

public section.
  type-pools ABAP .

  types:
    BEGIN OF ts_f4_table,
        field TYPE string,
        tab   TYPE REF TO data,
      END OF ts_f4_table .
  types:
    tt_f4_table TYPE SORTED TABLE OF ts_f4_table WITH UNIQUE KEY field .

  methods CONSTRUCTOR
    importing
      !IR_TABLE type ref to DATA
      !IT_TOOLBAR type TTB_BUTTON optional
      !IT_MOD_CATALOG type LVC_T_FCAT optional
      !IS_LAYOUT type LVC_S_LAYO optional
      !IS_VARIANT type DISVARIANT optional
      !IT_FILTER type LVC_T_FILT optional
      !IT_SORT type LVC_T_SORT optional .
  methods GET_GRID
    returning
      value(RO_GRID) type ref to CL_GUI_ALV_GRID .
  methods SET_FIELD_DESC
    importing
      !IS_FIELD_DESC type ref to ZCL_EUI_TYPE=>TS_FIELD_DESC .
  methods SET_F4_TABLE
    importing
      !IT_F4_TABLE type TT_F4_TABLE .
  methods SET_TOP_OF_PAGE_HEIGHT
    importing
      !IV_TOP_OF_PAGE_HEIGHT type I default 12  "#EC NUMBER_OK
    returning
      value(RO_ALV) type ref to ZCL_EUI_ALV .
  methods ADD_BUTTON
    importing
      !IS_BUTTON type STB_BUTTON
      !IO_HANDLER type ref to OBJECT optional
      !IV_HANDLERS_MAP type CSEQUENCE optional .
  class-methods UPDATE_COMPLEX_FIELDS
    importing
      !IR_TABLE type ref to DATA
      !IT_SUB_FIELD type ZCL_EUI_TYPE=>TT_FIELD_DESC optional
      !IS_SUB_FIELD type ZCL_EUI_TYPE=>TS_FIELD_DESC optional .

  methods ZIF_EUI_MANAGER~PAI
    redefinition .
  methods ZIF_EUI_MANAGER~PBO
    redefinition .

  events CHANGE_STYLES.
protected section.
private section.
ENDCLASS.



CLASS ZCL_EUI_ALV IMPLEMENTATION.


METHOD add_button.
ENDMETHOD.


METHOD constructor.
ENDMETHOD.


METHOD get_grid.
ENDMETHOD.


METHOD set_f4_table.
ENDMETHOD.


METHOD set_field_desc.
ENDMETHOD.


METHOD set_top_of_page_height.
ENDMETHOD.

METHOD update_complex_fields.
ENDMETHOD.


METHOD zif_eui_manager~pai.
ENDMETHOD.


METHOD zif_eui_manager~pbo.
ENDMETHOD.

ENDCLASS.
