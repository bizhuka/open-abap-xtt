FUNCTION scms_string_to_ftext.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(TEXT) TYPE  STRING
*"  EXPORTING
*"     VALUE(LENGTH) TYPE  I
*"  TABLES
*"      FTEXT_TAB
*"----------------------------------------------------------------------

  DATA:
    lr_line     TYPE REF TO data,
    lv_pos      TYPE i,
    lv_line_len TYPE i,
    lo_descr    TYPE REF TO cl_abap_typedescr.

  FIELD-SYMBOLS:
    <ls_line> TYPE any,
    <lv_text> TYPE any.

  CLEAR ftext_tab.
  length = strlen( text ).

  CREATE DATA lr_line LIKE LINE OF ftext_tab.
  ASSIGN lr_line->* TO <ls_line>.

  ASSIGN COMPONENT 1 OF STRUCTURE <ls_line> TO <lv_text>.
  IF sy-subrc <> 0.
    ASSIGN <ls_line> TO <lv_text>.
  ENDIF.

  lo_descr = cl_abap_typedescr=>describe_by_data( <lv_text> ).
  IF lo_descr->type_kind = cl_abap_typedescr=>typekind_string.
    <lv_text> = text.
    APPEND <ls_line> TO ftext_tab.
    RETURN.
  ENDIF.

  DESCRIBE FIELD <lv_text> LENGTH lv_line_len IN CHARACTER MODE.
  IF lv_line_len = 0.
    lv_line_len = 255.
  ENDIF.

  lv_pos = 0.
  WHILE lv_pos < length.
    CLEAR <ls_line>.
    <lv_text> = text+lv_pos.
    APPEND <ls_line> TO ftext_tab.
    lv_pos = lv_pos + lv_line_len.
  ENDWHILE.

ENDFUNCTION.
