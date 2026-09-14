FUNCTION scms_binary_to_xstring.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT_LENGTH) TYPE  I
*"  EXPORTING
*"     VALUE(BUFFER) TYPE  XSTRING
*"  TABLES
*"      BINARY_TAB
*"  EXCEPTIONS
*"      FAILED
*"----------------------------------------------------------------------

  FIELD-SYMBOLS:
    <ls_line> TYPE any,
    <lv_hex>  TYPE x.

  DATA:
    lv_line_len TYPE i,
    lv_rest     TYPE i.

  CLEAR buffer.

  " If requested length is zero or negative, return empty buffer
  IF input_length <= 0.
    RETURN.
  ENDIF.

  lv_rest = input_length.

  LOOP AT binary_tab ASSIGNING <ls_line>.
    " Assign component 1 (for structures like SOLIX) or the entire line with byte casting
    ASSIGN COMPONENT 1 OF STRUCTURE <ls_line> TO <lv_hex> CASTING.
    IF sy-subrc <> 0.
      ASSIGN <ls_line> TO <lv_hex> CASTING.
    ENDIF.

    CHECK <lv_hex> IS ASSIGNED.

    " Determine byte length of a single line once
    IF lv_line_len IS INITIAL.
      DESCRIBE FIELD <lv_hex> LENGTH lv_line_len IN BYTE MODE.
    ENDIF.

    " Append only what is needed
    IF lv_rest < lv_line_len.
      CONCATENATE buffer <lv_hex>(lv_rest) INTO buffer IN BYTE MODE.
      EXIT.
    ELSE.
      CONCATENATE buffer <lv_hex> INTO buffer IN BYTE MODE.
      lv_rest = lv_rest - lv_line_len.
      IF lv_rest = 0.
        EXIT.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFUNCTION.