class ZCL_EUI_SCREEN definition
  public
  inheriting from ZCL_EUI_MSG_MANAGER
  final
  create public .

public section.

  types:
    BEGIN OF ts_screen.
        INCLUDE TYPE screen.
      TYPES:
        t_listbox TYPE vrm_values,
      END OF ts_screen .
  types:
    tt_screen TYPE STANDARD TABLE OF ts_screen WITH DEFAULT KEY .
  types:
    BEGIN OF ts_map.
        INCLUDE TYPE zcl_eui_type=>ts_field_desc AS field_desc.
      TYPES:
*     @see get_screen_by_map
*    input       TYPE char1,
*    required    TYPE char1,

        cur_value   TYPE REF TO data,
        par_name    TYPE string,
        is_list_box TYPE abap_bool,
        command     TYPE syucomm,
      END OF ts_map .
  types:
    tt_map TYPE STANDARD TABLE OF ts_map WITH DEFAULT KEY .
  types:
    BEGIN OF ts_customize,
        name        TYPE screen-name,
        group1      TYPE screen-group1,
        group2      TYPE screen-group2,
        required    TYPE screen-required,
        input       TYPE screen-input,
        output      TYPE screen-output,
        invisible   TYPE screen-invisible,
        intensified TYPE screen-intensified,
        active      TYPE screen-active,
        t_listbox   TYPE vrm_values,

        " For map
        label      TYPE zcl_eui_type=>ts_field_desc-label,
        sub_fdesc  TYPE zcl_eui_type=>ts_field_desc-sub_fdesc,
        rollname   TYPE zcl_eui_type=>ts_field_desc-rollname,
        command    TYPE syucomm,
      END OF ts_customize .
  types:
    tt_customize TYPE STANDARD TABLE OF ts_customize WITH DEFAULT KEY .

  constants:
    BEGIN OF mc_dynnr,
        dynamic   TYPE sydynnr VALUE 'DYNC',
        free_sel  TYPE sydynnr VALUE 'FREE',
*        auto_gen  TYPE sydynnr VALUE 'AUTO',
*        dyn_popup TYPE sydynnr VALUE 'DPOP',
      END OF mc_dynnr .

  methods CONSTRUCTOR
    importing
      !IV_DYNNR type SYDYNNR
      !IV_CPROG type SYCPROG default SY-CPROG
      !IR_CONTEXT type ref to DATA optional
      !IV_EDITABLE type ABAP_BOOL default ABAP_TRUE
    raising
      ZCX_EUI_EXCEPTION .
  methods CUSTOMIZE
    importing
      !IT_ type TT_CUSTOMIZE optional
      !NAME type CSEQUENCE optional
      !GROUP1 type SCREEN-GROUP1 optional
      !GROUP2 type SCREEN-GROUP2 optional
      !REQUIRED type SCREEN-REQUIRED optional
      !INPUT type SCREEN-INPUT optional
      !OUTPUT type SCREEN-OUTPUT optional
      !INVISIBLE type SCREEN-INVISIBLE optional
      !INTENSIFIED type SCREEN-INTENSIFIED optional
      !ACTIVE type SCREEN-ACTIVE optional
      !IT_LISTBOX type VRM_VALUES optional
      !IV_LABEL type CSEQUENCE optional
      !IV_SUB_FDESC type ZCL_EUI_TYPE=>TS_FIELD_DESC-SUB_FDESC optional
      !IV_ROLLNAME type ZCL_EUI_TYPE=>TS_FIELD_DESC-ROLLNAME optional
      !IV_COMMAND type SYUCOMM optional
    returning
      value(RO_SCREEN) type ref to ZCL_EUI_SCREEN .
  methods GET_CONTEXT
    importing
      !IV_READ type ABAP_BOOL default ABAP_TRUE
    returning
      value(RR_CONTEXT) type ref to DATA .
  methods GET_DIMENSION
    exporting
      !EV_COL_END type I .
  methods SET_INIT_PARAMS .
  class-methods EDIT_IN_POPUP
    importing
      !IV_TITLE type CSEQUENCE default 'Edit value'(EDT)
      !IV_LABEL type CSEQUENCE optional
      !IV_REQUIRED type ABAP_BOOL optional
      !IV_EDITABLE type ABAP_BOOL default ABAP_TRUE
    changing
      !CV_OK type ABAP_BOOL optional
      !CV_VALUE type ANY .
  class-methods CONFIRM
    importing
      !IV_TITLE type CSEQUENCE
      !IV_QUESTION type CSEQUENCE
      !IV_ICON_1 type ICON-NAME default 'ICON_OKAY'
      !IV_TEXT_1 type CSEQUENCE optional
      !IV_ICON_2 type ICON-NAME default 'ICON_CANCEL'
      !IV_TEXT_2 type CSEQUENCE optional
      !IV_DEFAULT type CHAR1 default '2'
      !IV_DISPLAY_CANCEL type ABAP_BOOL optional
    returning
      value(RV_OK) type ABAP_BOOL .
  class-methods SHOW_RANGE
    importing
      !IS_FIELD_DESC type ZCL_EUI_TYPE=>TS_FIELD_DESC
      !IR_CUR_VALUE type ref to DATA
      !IV_READ_ONLY type ABAP_BOOL
    returning
      value(RV_UPDATE) type ABAP_BOOL .
  class-methods TOP_PBO .
  class-methods TOP_PAI
    importing
      !IV_UCOMM type SYUCOMM .

  methods ZIF_EUI_MANAGER~PAI
    redefinition .
  methods ZIF_EUI_MANAGER~PBO
    redefinition .
  methods ZIF_EUI_MANAGER~SHOW
    redefinition .
protected section.
private section.

ENDCLASS.



CLASS ZCL_EUI_SCREEN IMPLEMENTATION.


METHOD confirm.
ENDMETHOD.


METHOD constructor.
ENDMETHOD.


METHOD customize.
ENDMETHOD.


METHOD edit_in_popup.
ENDMETHOD.


METHOD get_context.
ENDMETHOD.


METHOD get_dimension.
ENDMETHOD.


METHOD set_init_params.
ENDMETHOD.


METHOD show_range.
ENDMETHOD.


METHOD top_pai.
ENDMETHOD.


METHOD top_pbo.
ENDMETHOD.


METHOD zif_eui_manager~pai.
ENDMETHOD.


METHOD zif_eui_manager~pbo.
ENDMETHOD.


METHOD zif_eui_manager~show.
ENDMETHOD.
ENDCLASS.
