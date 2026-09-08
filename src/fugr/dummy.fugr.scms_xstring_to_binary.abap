FUNCTION scms_xstring_to_binary.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(BUFFER) TYPE  XSTRING
*"  EXPORTING
*"     VALUE(OUTPUT_LENGTH) TYPE  I
*"  TABLES
*"      BINARY_TAB
*"----------------------------------------------------------------------

  DATA:
    lr_line     TYPE REF TO data,
    lv_pos      TYPE i,
    lv_len      TYPE i,
    lv_line_len TYPE i.

  FIELD-SYMBOLS:
    <ls_line>  TYPE any,
    <lv_field> TYPE any.

  CLEAR binary_tab.
  output_length = xstrlen( buffer ).

  CREATE DATA lr_line LIKE LINE OF binary_tab.
  ASSIGN lr_line->* TO <ls_line>.

  ASSIGN COMPONENT 1 OF STRUCTURE <ls_line> TO <lv_field>.
  IF sy-subrc <> 0.
    ASSIGN <ls_line> TO <lv_field>.
  ENDIF.

  DESCRIBE FIELD <lv_field> LENGTH lv_line_len IN BYTE MODE.
  IF lv_line_len = 0 OR output_length = 0.
    RETURN.
  ENDIF.

  lv_pos = 0.
  WHILE lv_pos < output_length.
    lv_len = output_length - lv_pos.
    IF lv_len > lv_line_len.
      lv_len = lv_line_len.
    ENDIF.

    CLEAR <ls_line>.
    <lv_field> = buffer+lv_pos(lv_len).
    APPEND <ls_line> TO binary_tab.

    lv_pos = lv_pos + lv_len.
  ENDWHILE.

ENDFUNCTION.
