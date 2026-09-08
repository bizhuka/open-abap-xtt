FUNCTION scms_binary_to_string.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT_LENGTH) TYPE  I
*"     VALUE(ENCODING) TYPE  ABAP_ENCOD OPTIONAL
*"  EXPORTING
*"     VALUE(TEXT_BUFFER) TYPE  STRING
*"  TABLES
*"      BINARY_TAB
*"  EXCEPTIONS
*"      FAILED
*"----------------------------------------------------------------------

  DATA:
    lv_buffer   TYPE xstring,
    lv_encoding TYPE abap_encod,
    lo_conv     TYPE REF TO cl_abap_conv_in_ce.

  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING
      input_length = input_length
    IMPORTING
      buffer       = lv_buffer
    TABLES
      binary_tab   = binary_tab.

  lv_encoding = encoding.
  IF lv_encoding IS INITIAL OR lv_encoding = '4110'.
    lv_encoding = 'UTF-8'.
  ENDIF.

  lo_conv = cl_abap_conv_in_ce=>create(
    encoding = lv_encoding
    input    = lv_buffer ).

  lo_conv->read(
    IMPORTING
      data = text_buffer ).

ENDFUNCTION.
