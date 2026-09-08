CLASS zcl_test_conv DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_test_conv IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA lv_string     TYPE string VALUE 'Hello ABAP!'.
    DATA lv_xstring    TYPE xstring.
    DATA lv_string_out TYPE string.
    DATA lv_base64     TYPE string.
    DATA lt_binary     TYPE solix_tab.
    DATA lt_text       TYPE STANDARD TABLE OF string.
    DATA lv_length     TYPE i.

    " 1. String to XString
    lv_xstring = zcl_eui_conv=>string_to_xstring( iv_string = lv_string ).
    out->write( |String to Xstring: { lv_xstring }| ).

    " 2. XString to Base64
    lv_base64 = zcl_eui_conv=>xstring_to_base64( iv_xstring = lv_xstring ).
    out->write( |XString to Base64: { lv_base64 }| ).

    " 3. XString to Binary
    zcl_eui_conv=>xstring_to_binary( EXPORTING iv_xstring = lv_xstring
                                     IMPORTING et_table   = lt_binary
                                               ev_length  = lv_length ).
    out->write( |XString to Binary: Table Rows: { lines( lt_binary ) }, Length: { lv_length }| ).

    " 4. Binary to String
    lv_string_out = zcl_eui_conv=>binary_to_string( it_table  = lt_binary
                                                    iv_length = lv_length ).
    out->write( |Binary to String: { lv_string_out }| ).

    " 5. String to Text table
    zcl_eui_conv=>string_to_text_table( EXPORTING iv_string = lv_string
                                        IMPORTING et_text   = lt_text
                                                  ev_length = lv_length ).
    out->write( |String to Text Table: Table Rows: { lines( lt_text ) }| ).
  ENDMETHOD.
ENDCLASS.
