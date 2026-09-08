FUNCTION scms_string_to_xstring.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(TEXT) TYPE  STRING
*"     VALUE(ENCODING) TYPE  ABAP_ENCOD OPTIONAL
*"  EXPORTING
*"     VALUE(BUFFER) TYPE  XSTRING
*"  EXCEPTIONS
*"      FAILED
*"----------------------------------------------------------------------

  DATA:
    lv_encoding TYPE abap_encod,
    lo_convert  TYPE REF TO cl_abap_conv_out_ce.

  lv_encoding = encoding.
  IF lv_encoding IS INITIAL OR lv_encoding = '4110'.
    lv_encoding = 'UTF-8'.
  ENDIF.

  lo_convert = cl_abap_conv_out_ce=>create(
    encoding    = lv_encoding
    ignore_cerr = abap_true ).

  lo_convert->write( data = text ).
  buffer = lo_convert->get_buffer( ).

ENDFUNCTION.
