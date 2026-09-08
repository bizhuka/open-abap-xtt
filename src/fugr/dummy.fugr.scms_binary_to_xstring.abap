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
    <ls_line>  TYPE any,
    <lv_field> TYPE any.

  CLEAR buffer.

  LOOP AT binary_tab ASSIGNING <ls_line>.
    ASSIGN COMPONENT 1 OF STRUCTURE <ls_line> TO <lv_field>.
    IF sy-subrc <> 0.
      ASSIGN <ls_line> TO <lv_field>.
    ENDIF.
    CHECK <lv_field> IS ASSIGNED.
    CONCATENATE buffer <lv_field> INTO buffer IN BYTE MODE.
  ENDLOOP.

  IF input_length > 0 AND xstrlen( buffer ) > input_length.
    buffer = buffer(input_length).
  ENDIF.

ENDFUNCTION.
